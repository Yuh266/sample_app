document.addEventListener("turbo:load", () => {
  initializeTags();
});

document.addEventListener("turbo:frame-load", () => {
  initializeTags();
});

document.addEventListener("turbo:render", () => {
  initializeTags();
});

const initializeTags = () => {
  let addedTags = []; // Mảng toàn cục lưu trữ các tags đã thêm

  const tagsContainer = document.getElementById("tags-container");
  const selectedTagsContainer = document.getElementById("selected-tags");
  const tagError = document.getElementById("tag-error");

  if (!tagsContainer || !selectedTagsContainer || !tagError) return;

  // Hàm thêm tag vào danh sách hiển thị
  const addTag = (tag) => {
    if (addedTags.includes(tag.trim().toLowerCase())) {
      tagError.textContent = "Tag đã tồn tại!";
      tagError.style.color = "red";
      return;
    }

    tagError.textContent = "";
    addedTags.push(tag.trim().toLowerCase());

    const tagElement = document.createElement("span");
    tagElement.className = "tag-item";
    tagElement.textContent = tag;

    const removeButton = document.createElement("button");
    removeButton.type = "button";
    removeButton.textContent = "×";
    removeButton.className = "remove-tag";
    removeButton.style.marginLeft = "5px";
    removeButton.addEventListener("click", () => {
      tagElement.remove();
      const index = addedTags.indexOf(tag.trim().toLowerCase());
      if (index > -1) {
        addedTags.splice(index, 1);
      }
    });

    tagElement.appendChild(removeButton);
    selectedTagsContainer.appendChild(tagElement);

    // Tạo trường input mới trong fields_for
    const timestamp = new Date().getTime();
    const newTagField = document.createElement("div");
    newTagField.className = "tag-field";
    newTagField.style.marginBottom = "10px";
    newTagField.innerHTML = `
      <input type="text" name="micropost[taggings_attributes][${timestamp}][tag_attributes][name]" value="${tag}" class="tag-input" readonly>
    `;
    tagsContainer.appendChild(newTagField);
  };

  // Xử lý sự kiện khi nhấn Enter trong trường input
  document.addEventListener("keydown", (e) => {
    if (e.target.classList.contains("tag-input") && e.key === "Enter") {
      e.preventDefault(); // Ngăn chặn hành vi mặc định của phím Enter
      const tagInput = e.target;
      const tag = tagInput.value.trim();
      if (tag) {
        addTag(tag);
        tagInput.value = "";
      }
    }
  });

  // Gợi ý tag khi nhập
  const tagInput = document.querySelector(".tag-input");
  const tagSuggestions = document.createElement("ul");
  tagSuggestions.className = "tag-suggestions";

  if (tagInput) {
    // Đảm bảo cha của tagInput có position: relative
    tagInput.parentNode.style.position = "relative";
    tagInput.parentNode.appendChild(tagSuggestions);

    tagInput.addEventListener("input", async (e) => {
      const query = e.target.value.trim();
      if (query.length === 0) {
        tagSuggestions.innerHTML = "";
        return;
      }

      try {
        const response = await fetch(`/tags/search?q=${encodeURIComponent(query)}`);
        if (!response.ok) throw new Error("Failed to fetch tags");
        const tags = await response.json();

        tagSuggestions.innerHTML = "";
        tags.forEach((tag) => {
          const suggestionItem = document.createElement("li");
          suggestionItem.textContent = tag;
          suggestionItem.addEventListener("click", () => {
            tagInput.value = tag; // Gán giá trị tag vào input
            tagSuggestions.innerHTML = ""; // Xóa danh sách gợi ý
          });

          tagSuggestions.appendChild(suggestionItem);
        });
      } catch (error) {
        console.error("Error fetching tags:", error);
      }
    });

    document.addEventListener("click", (e) => {
      if (!tagSuggestions.contains(e.target) && e.target !== tagInput) {
        tagSuggestions.innerHTML = ""; // Ẩn danh sách gợi ý khi click ra ngoài
      }
    });
  }
};

initializeTags();

document.addEventListener("turbo:submit-end", (event) => {
  const form = document.getElementById("micropost_form"); // ID của form
  if (form && event.detail.success) {
    console.log("Form submitted successfully!");

    // Reset form
    form.reset();

    // Xóa danh sách tag đã chọn
    const selectedTagsContainer = document.getElementById("selected-tags");
    if (selectedTagsContainer) {
      selectedTagsContainer.innerHTML = ""; // Xóa tất cả các tag đã thêm
    }
    
    const tagsContainer = document.getElementById("tags-container");
    if (tagsContainer) {
      const tagFields = tagsContainer.querySelectorAll(".tag-field");
      tagFields.forEach((field, index) => {
        if (index > 0) field.remove(); // Xóa tất cả các tag input trừ cái đầu tiên
      });
    }
    
  }
});