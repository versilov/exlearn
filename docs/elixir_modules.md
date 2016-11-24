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

##### Structure:

| Name         | Type | Schema                                  |
|--------------|------|-----------------------------------------|
| **layers**   | map  | [layers](#nn-create-layers)             |
| objective    | atom | [objective](#nn-create-objective)       |
| presentation | atom | [presentation](#nn-create-presentation) |

##### <a name="nn-create-layers"></a> Layers:

| Key        | Type | Schema                      |
|------------|------|-----------------------------|
| **input**  | map  | [input](#nn-create-input)   |
| **hidden** | list | [hidden](#nn-create-hidden) |
| **output** | map  | [output](#nn-create-output) |

##### <a name="nn-create-input"></a> Input:

| Key        | Type     | Schema                              |
|------------|----------|-------------------------------------|
| **size**   | map      | [input](#nn-create-input)           |
| activation | atom     | [activation](#nn-create-activation) |
| dropout    | map      | [output](#nn-create-output)         |
| name       | String.t | Any non empty elixir string.        |

##### <a name="nn-create-hidden"></a> Hidden:

##### <a name="nn-create-output"></a> Output:

##### <a name="nn-create-objective"></a> Objective:

| Value                      | Type | Description |
|----------------------------|------|-------------|
| `:cross_entropy`           | atom |             |
| `:negative_log_likelihood` | atom |             |
| `:quadratic`               | atom |             |

Default Value: `:quadratic`

##### <a name="nn-create-presentation"></a> Presentation:

| Value     | Type | Description |
|-----------|------|-------------|
| `:argmax` | atom |             |
| `:raw`    | atom |             |
| `:round`  | atom |             |

Default Value: `:raw`

#### Return

