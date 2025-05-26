document.addEventListener("turbo:load", () => {
  const tagsContainer = document.getElementById("tags-container");
  const selectedTagsContainer = document.getElementById("selected-tags");
  const tagError = document.getElementById("tag-error"); // Phần tử hiển thị lỗi
  const addedTags = []; // Mảng lưu trữ các tags đã thêm

  if (!tagsContainer || !selectedTagsContainer || !tagError) return;

  // Hàm thêm tag vào danh sách hiển thị
  const addTag = (tag) => {
    // Kiểm tra nếu tag đã tồn tại trong mảng
    if (addedTags.includes(tag.trim().toLowerCase())) {
      tagError.textContent = "Tag đã tồn tại!"; // Hiển thị thông báo lỗi
      tagError.style.color = "red"; // Đặt màu đỏ cho thông báo lỗi
      return;
    }

    // Xóa thông báo lỗi nếu tag hợp lệ
    tagError.textContent = "";

    // Thêm tag vào mảng
    addedTags.push(tag.trim().toLowerCase());

    // Hiển thị tag trong danh sách
    const tagElement = document.createElement("span");
    tagElement.className = "tag-item";
    tagElement.textContent = tag;

    // Nút xóa tag
    const removeButton = document.createElement("button");
    removeButton.type = "button";
    removeButton.textContent = "×";
    removeButton.className = "remove-tag";
    removeButton.style.marginLeft = "5px";
    removeButton.addEventListener("click", () => {
      // Xóa tag khỏi danh sách hiển thị
      tagElement.remove();

      // Xóa tag khỏi mảng
      const index = addedTags.indexOf(tag.trim().toLowerCase());
      if (index > -1) {
        addedTags.splice(index, 1); // Xóa tag khỏi mảng
      }

      // Xóa trường input tương ứng trong #tags-container
      const inputToRemove = Array.from(tagsContainer.querySelectorAll("input")).find(
        (input) => input.value.trim().toLowerCase() === tag.trim().toLowerCase()
      );
      if (inputToRemove) {
        inputToRemove.parentElement.remove(); // Xóa toàn bộ thẻ chứa input
      }
    });

    tagElement.appendChild(removeButton);
    selectedTagsContainer.appendChild(tagElement);

    // Tạo trường input mới trong fields_for
    const timestamp = new Date().getTime();
    const newTagField = document.createElement("div");
    newTagField.className = "tag-field";
    newTagField.style.marginBottom = "10px";
    newTagField.style.padding = "10px";
    newTagField.style.border = "1px solid #ccc";

    newTagField.innerHTML = `
      <input type="text" name="micropost[taggings_attributes][${timestamp}][tag_attributes][name]" value="${tag}" class="tag-input" readonly>
    `;
    tagsContainer.appendChild(newTagField);

    // Ẩn trường nhập mới
    newTagField.style.display = "none";
  };

  // Xử lý sự kiện khi nhấn Enter trong trường input
  document.addEventListener("keydown", (e) => {
    if (e.target.classList.contains("tag-input") && e.key === "Enter") {
      e.preventDefault(); // Ngăn form submit
      const tagInput = e.target;
      const tag = tagInput.value.trim();
      if (tag) {
        addTag(tag); // Thêm tag vào danh sách
        tagInput.value = ""; // Làm mới trường input
      }
    }
  });
});