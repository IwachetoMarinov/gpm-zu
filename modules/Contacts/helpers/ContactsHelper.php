<?php

/**
 * ContactsHelper.php
 *
 * Shared helper for Contacts views that convert HTML to PDF via wkhtmltopdf
 * and stream the result. Matches the legacy downloadPDF() behavior in each view.
 */
final class ContactsHelper
{
    /**
     * Get the metal name from the code
     * 
     * @param string $code The metal code
     * @return string The metal name
     */
    public static function getMetalName(string $code): string
    {
        $metal_names = [
            'XAU' => 'Gold',
            'XAG' => 'Silver',
            'XPT' => 'Platinum',
            'XPD' => 'Palladium',
            'XPL' => 'Palladium',
            'MBTC' => 'mBitCoin',
        ];

        return $metal_names[$code] ?? '';
    }

    /**
     * Get the average spot price from the items
     * 
     * @param array $items The items
     * @return float The average spot price
     */
    public static function getAverageSpotPrice(array $items): float
    {
        $totalSpotPrice = 0.00;
        $count = 0;

        if (empty($items)) return $totalSpotPrice;

        foreach ($items as $item) {
            if (isset($item->averageSpotPrice) && $item->averageSpotPrice > 0) {
                $totalSpotPrice += $item->averageSpotPrice;
                $count++;
            }
        }

        return $count > 0 ? round($totalSpotPrice / $count, 2) : 0.00;
    }
}
