class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    this.action,
    this.hint,
    required this.onTap,
  });


  final String title;
  final String? action;
  final String? hint;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(17, weight: FontWeight.w600),
            ),
          ),
          if (action == null) ...[
            const Icon(Icons.chevron_right, color: AppColors.gold),
            // Revisi usability (Temuan 2): petunjuk bahwa kartu bisa di-tap.
            if (hint != null)
              Expanded(
                child: Text(
                  hint!,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body(11, color: AppColors.textTertiary),
                ),
              ),
          ] else ...[
            const Spacer(),
            Text(
              action!,
              style: AppText.body(
                12,
                weight: FontWeight.w500,
                color: AppColors.gold,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gold, size: 18),
          ],
        ],
      ),
    );
  }
}
