---
name: rn-component-patterns
description: React Native component pattern'leri. Screen, form, list, modal olusturma. UI implement ederken kullan.
---

## Screen Template
```typescript
export default function ProfileScreen() {
  const { data, isLoading, error } = useProfile();
  if (isLoading) return <ScreenSkeleton />;
  if (error) return <ErrorView retry={refetch} />;
  return <ScrollView className="flex-1 bg-white p-4">...</ScrollView>;
}
```

## Form Pattern (react-hook-form + zod)
```typescript
const schema = z.object({ email: z.string().email(), password: z.string().min(8) });
type FormData = z.infer<typeof schema>;

export function LoginForm() {
  const { control, handleSubmit } = useForm<FormData>({ resolver: zodResolver(schema) });
  const onSubmit = (data: FormData) => loginMutation.mutate(data);
  return <View>
    <Controller control={control} name="email" render={({field, fieldState}) => (
      <TextInput className={fieldState.error ? 'border-red-500' : 'border-gray-300'} {...field} />
    )} />
  </View>;
}
```

## List Pattern
```typescript
// Buyuk listeler icin DAIMA FlatList, ScrollView degil
<FlatList
  data={items}
  keyExtractor={(item) => item.id}
  renderItem={({ item }) => <ItemCard item={item} />}
  onEndReached={fetchNextPage}
  onEndReachedThreshold={0.5}
  ListEmptyComponent={<EmptyState />}
/>
```
