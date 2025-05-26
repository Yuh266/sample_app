document.addEventListener("turbo:load", () => {
  const tagsContainer = document.getElementById("tags-container");
  const addTagButton = document.getElementById("add-tag");

  if (!tagsContainer || !addTagButton) return;

  // Xử lý thêm trường nhập tag
  addTagButton.addEventListener("click", () => {
    const timestamp = new Date().getTime(); // Tạo một ID duy nhất cho trường mới
    const newTagField = document.createElement("div");
    newTagField.className = "tag-field";
    newTagField.style.marginBottom = "10px";
    newTagField.style.padding = "10px";
    newTagField.style.border = "1px solid #ccc";

    // Tạo cấu trúc HTML cho trường input mới
    newTagField.innerHTML = `
      <input type="text" name="micropost[taggings_attributes][${timestamp}][tag_attributes][name]" id="micropost_taggings_attributes_${timestamp}_tags_attributes_name" placeholder="Enter a tag" class="tag-input">
      <button type="button" class="remove-tag btn btn-danger">×</button>
    `;
    tagsContainer.appendChild(newTagField);

    // Gắn autocomplete cho trường mới
    attachAutocomplete(newTagField.querySelector(".tag-input"));
  });

  // Xử lý xóa trường nhập tag
  tagsContainer.addEventListener("click", (e) => {
    if (e.target.classList.contains("remove-tag")) {
      const tagField = e.target.closest(".tag-field");
      if (tagField) {
        tagsContainer.removeChild(tagField);
      }
    }
  });

  // Hàm gắn autocomplete cho một trường input
  function attachAutocomplete(tagInput) {
    const tagSuggestions = document.createElement("ul");
    tagSuggestions.className = "tag-suggestions";
    tagSuggestions.style.position = "absolute";
    tagSuggestions.style.backgroundColor = "white";
    tagSuggestions.style.border = "1px solid #ccc";
    tagSuggestions.style.listStyle = "none";
    tagSuggestions.style.padding = "0";
    tagSuggestions.style.margin = "0";
    tagSuggestions.style.width = "100%";
    tagSuggestions.style.zIndex = "1000";

    tagInput.parentNode.style.position = "relative"; // Đảm bảo cha có `position: relative`
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
          suggestionItem.style.padding = "0.5rem";
          suggestionItem.style.cursor = "pointer";

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

  // Gắn autocomplete cho tất cả các trường input hiện tại
  document.querySelectorAll(".tag-input").forEach((tagInput) => {
    attachAutocomplete(tagInput);
  });
});