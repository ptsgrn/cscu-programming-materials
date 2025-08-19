// {
//   "kind": { "grid": true },
//   "text": "test",
//     "columnLabels": [
//       {
//         "label": "test"
//       }
//     ],
//       "rows": [
//         {
//           "label": "foo",
//           "columns": [
//             {
//               "content": "a",
//               "tag": "a"
//             },
//             {
//               "content": "b",
//               "tag": "b"
//             }
//           ]
//         }
//       ]
// }

export function stackViz(data: Record<string, (string | number)[]>) {
  return JSON.stringify({
    kind: { grid: true },
    text: "test",
    columnLabels: [
      {
        label: "test"
      }
    ],
    rows: Object.entries(data).map(([label, columns]) => ({
      label,
      columns: columns.map((content, index) => ({
        content,
        tag: `col${index}`
      }))
    }))
  });
}
