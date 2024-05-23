return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
        'php-debug-adapter',
      },
    }

    -- Basic debugging keymaps
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup with customized layout
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.7 }, -- Increase the size of the scopes window
            { id = 'breakpoints', size = 0.1 },
            { id = 'stacks', size = 0.1 },
            { id = 'watches', size = 0.1 },
          },
          size = 60, -- Width of the left layout
          position = 'left',
        },
        {
          elements = {
            'repl',
            'console',
          },
          size = 15, -- Height of the bottom layout
          position = 'bottom',
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      windows = { indent = 1 },
    }

    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Keybinding to quit debugger
    vim.keymap.set('n', '<leader>dq', function()
      dap.terminate()
      dapui.close()
    end, { desc = 'Debug: Quit Debugger' })

    -- PHP Xdebug configuration
    dap.adapters.php = {
      type = 'executable',
      command = 'node',
      args = { '/home/west/Downloads/vscode-php-debug/out/phpDebug.js' },
    }

    dap.configurations.php = {
      {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
        pathMappings = {
          ['/var/www/app'] = '/home/west/bluearrow/base-project/app',
          ['/var/www/config'] = '/home/west/bluearrow/base-project/config',
          ['/var/www/database'] = '/home/west/bluearrow/base-project/database',
          ['/var/www/public'] = '/home/west/bluearrow/base-project/public',
          ['/var/www/resources'] = '/home/west/bluearrow/base-project/resources',
          ['/var/www/routes'] = '/home/west/bluearrow/base-project/routes',
          ['/var/www/storage'] = '/home/west/bluearrow/base-project/storage',
          ['/var/www/tests'] = '/home/west/bluearrow/base-project/tests',
          ['/var/www/scripts'] = '/home/west/bluearrow/base-project/scripts',
          ['/var/www/vendor'] = '/home/west/bluearrow/base-project/vendor',
          ['/var/www/artisan'] = '/home/west/bluearrow/base-project/artisan',
        },
      },
    }
  end,
}
