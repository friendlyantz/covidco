import $ from 'jquery';
import 'select2';

const initSelect2 = () => {
  $('.select2').select2({
    placeholder: "Search keywords",
    allowClear: true,
    width: '100%',
    multiple: true
  });
};

export { initSelect2 };
