module ApplicationTemplateHelper
  def button_klasses(theme:)
    themes = {
      emerald: "text-white bg-zinc-900 hover:bg-zinc-700 " \
               "dark:bg-emerald-400/10 dark:text-emerald-400 dark:ring-1 dark:ring-inset " \
               "dark:ring-emerald-400/20 dark:hover:bg-emerald-400/10 dark:hover:text-emerald-300 " \
               "dark:hover:ring-emerald-300",
      zinc: "text-zinc-700 ring-1 ring-inset ring-zinc-900/10 hover:bg-zinc-900/2.5 " \
            "hover:text-zinc-900 dark:text-zinc-400 dark:ring-white/10 dark:hover:bg-white/5 dark:hover:text-white",
      mauve: "text-white bg-zinc-900 hover:bg-zinc-700 " \
             "dark:bg-mauve-400/10 dark:text-mauve-400 dark:ring-1 dark:ring-inset " \
             "dark:ring-mauve-400/20 dark:hover:bg-mauve-400/10 dark:hover:text-mauve-300 " \
             "dark:hover:ring-mauve-300"
    }
    klasses = "inline-flex gap-0.5 justify-center overflow-hidden text-sm font-medium transition rounded-full py-1 px-3 "

    "#{klasses} #{themes[theme]}"
  end

  def link_klasses(theme:)
    themes = {
      emerald: "text-emerald-500 hover:text-emerald-600 dark:text-emerald-400 dark:hover:text-emerald-500",
      mauve: "text-mauve-500 hover:text-mauve-600 dark:text-mauve-400 dark:hover:text-mauve-500"
    }

    klasses = "inline-flex gap-0.5 justify-center overflow-hidden text-sm font-medium transition"

    "#{klasses} #{themes[theme]}"
  end

  def nav_link_klasses(url:)
    base_klasses = "flex justify-between gap-2 py-1 pr-3 text-sm transition pl-4"
    active_klasses = "text-zinc-900 dark:text-white border-l border-l-mauve-500"
    inactive_classes = "text-zinc-600 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-white"

    "#{base_klasses} #{is_link_active?(url:) ? active_klasses : inactive_classes}"
  end

  def link_active?(url:)
    (request.path.start_with?(url) && url != "/") || request.path == url
  end
end
