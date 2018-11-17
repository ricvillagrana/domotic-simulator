<template>
  <table class="table-fixed rounded bg-white">
    <thead>
      <tr>
        <th class="border-b-2 border border-grey-light py-2 px-8" v-for="(header, key) in headers" :key="`header-${key}`">{{ header }}</th>
      </tr>
    </thead>
    <tbody>
      <tr class="hover:bg-blue-lightest duration-1" v-for="(row, key) in data" :key="`data-${key}`">
        <td class="border border-grey-light py-2 px-4" v-for="(field, key) in fields" :key="`field-${key}`">{{ row[field] }}</td>
      </tr>
    </tbody>
  </table>
</template>

<script>
export default {
  name: 'app-table',
  props: ['headers', 'data', 'fields']
}
</script>
