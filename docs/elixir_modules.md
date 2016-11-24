# Elixir modules API reference

Table items in bold are mandatory.

## `ExLearn.NeuralNetwork`

### `#create\1`

Initializes the neural network processes and returns a handle. 

```elixir
structure = %{
  layers: %{
    input:   %{size: 784, dropout: 0.2                     },
    hidden: [%{size: 100, dropout: 0.5, activity: :logistic}],
    output:  %{size: 10,                activity: :logistic}
  },
  objective:    :cross_entropy,
  presentation: :argmax
}

create(structure)
```

#### Parameters

##### `structure`

| Name         | Type | Schema                                  |
|--------------|------|-----------------------------------------|
| **layers**   | map  | [layers](#nn-create-layers)             |
| objective    | atom | [objective](#nn-create-objective)       |
| presentation | atom | [presentation](#nn-create-presentation) |

#### Return

The function return a handle that must be passed to the other functions in order
for them to know on which network to operate.

#### Schemas

##### <a name="nn-create-layers"></a> `layers`:

| Key        | Type | Description                                |
|------------|------|--------------------------------------------|
| **input**  | map  | See the [input schema](#nn-create-input)   |
| **hidden** | list | See the [hidden schema](#nn-create-hidden) |
| **output** | map  | See the [output schema](#nn-create-output) |

##### <a name="nn-create-objective"></a> `objective`:

| Value                      | Type | Description |
|----------------------------|------|-------------|
| `:cross_entropy`           | atom |             |
| `:negative_log_likelihood` | atom |             |
| `:quadratic`               | atom |             |

Default Value: `:quadratic`

##### <a name="nn-create-presentation"></a> `presentation`:

| Value     | Type | Description |
|-----------|------|-------------|
| `:argmax` | atom |             |
| `:raw`    | atom |             |
| `:round`  | atom |             |

Default Value: `:raw`

##### <a name="nn-create-input"></a> `input`:

| Key        | Type        | Description                                        |
|------------|-------------|----------------------------------------------------|
| **size**   | pos_integer | The number of neurons for the current layer.       |
| dropout    | float       | The dropout probability, between [0, 1].           |
| name       | String.t    | Any non empty elixir string.                       |

##### <a name="nn-create-hidden"></a> `hidden`:

| Key        | Type        | Description                                        |
|------------|-------------|----------------------------------------------------|
| **size**   | pos_integer | The number of neurons for the current layer.       |
| activation | atom        | See the [activation schema](#nn-create-activation) |
| dropout    | float       | The dropout probability, between [0, 1].           |
| name       | String.t    | Any non empty elixir string.                       |

##### <a name="nn-create-output"></a> `output`:

| Key        | Type        | Description                                        |
|------------|-------------|----------------------------------------------------|
| **size**   | pos_integer | The number of neurons for the current layer.       |
| activation | atom        | See the [activation schema](#nn-create-activation) |
| name       | String.t    | Any non empty elixir string.                       |

##### <a name="nn-create-activation"></a> `activation`:

| Value                    | Type  | Description |
|--------------------------|-------|-------------|
| `:arctan`                | atom  |             |
| `:bent_identity`         | atom  |             |
| `:gaussian`              | atom  |             |
| `:identity`              | atom  |             |
| `:logistic`              | atom  |             |
| `:relu`                  | atom  |             |
| `:sinc`                  | atom  |             |
| `:sinusoid`              | atom  |             |
| `:softmax`               | atom  |             |
| `:softplus`              | atom  |             |
| `:softsign`              | atom  |             |
| `:tanh`                  | atom  |             |
| `{:elu,   alpha: alpha}` | tuple |             |
| `{:prelu, alpha: alpha}` | tuple |             |

Default Value: `:logistic`
