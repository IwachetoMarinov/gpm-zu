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

    /**
     * Precious metal types shown on PO / SO / STO order forms.
     *
     * @return list<string>
     */
    public static function getOrderFormMetals(): array
    {
        return [
            'Gold 999.9',
            'Silver 999.0',
            'Platinum 999.5',
            'Palladium 999.5',
        ];
    }

    /**
     * Weight column options for PO / SO / STO metals tables.
     *
     * @param string $otherGrams Label shown under the "Other" column (empty for SO/STO, "(pls specify)" for PO)
     * @return list<array{label: string, grams: string}>
     */
    public static function getOrderFormWeights(string $otherGrams = ''): array
    {
        return [
            ['label' => '1000oz', 'grams' => '31,103g'],
            ['label' => '400oz', 'grams' => '12,441g'],
            ['label' => '100oz', 'grams' => '3,110g'],
            ['label' => '32.15oz', 'grams' => '1,000g'],
            ['label' => '16.08oz', 'grams' => '500g'],
            ['label' => '10oz', 'grams' => '311g'],
            ['label' => '3.22oz', 'grams' => '100g'],
            ['label' => '1oz', 'grams' => '31g'],
            ['label' => 'Other', 'grams' => $otherGrams],
        ];
    }

    /**
     * Transaction fields excluded from TC warning checks on MPD / MRD print previews.
     *
     * @return list<string>
     */
    public static function getMpdMrdTransactionWarningExcludes(): array
    {
        return ['description', 'grand_total', 'matched_amt', 'currency', 'voucher_type'];
    }

    /**
     * Bar item fields excluded from TC warning checks on MPD / MRD print previews.
     *
     * @return list<string>
     */
    public static function getMpdMrdBarItemWarningExcludes(): array
    {
        return [
            'transaction_type',
            'currency',
            'metal_code',
            'metal_name',
            'metal_type_code',
            'tx_amount',
            'spot_price',
            'avg_spot_price',
            'posting_date',
            'exchange_rate',
            'fine_oz',
            'gross_oz',
            'purity',
            'item_price',
            'unit_price',
            'premium_perc',
            'premium_final',
            'total_item_amount',
            'total_item_dc_amount',
            'weight',
            'narration',
            'bar_number',
            'other_charge',
            'long_desc',
            'remarks',
        ];
    }

    /**
     * Transaction fields excluded from TC warning checks on TC print preview.
     *
     * @return list<string>
     */
    public static function getTcTransactionWarningExcludes(): array
    {
        return ['description', 'grand_total', 'matched_amt'];
    }

    /**
     * Bar item fields excluded from TC warning checks on TC print preview.
     *
     * @return list<string>
     */
    public static function getTcBarItemWarningExcludes(): array
    {
        return [
            'metal_code',
            'metal_name',
            'metal_type_code',
            'warehouse',
            'tx_amount',
            'avg_spot_price',
            'posting_date',
            'item_code',
            'fine_oz',
            'gross_oz',
            'purity',
            'total_item_dc_amount',
            'weight',
            'bar_number',
            'remarks',
            'other_charge',
            'narration',
            'long_desc',
            'exchange_rate',
            'item_price',
            'premium_final',
        ];
    }

    /**
     * Transaction fields excluded from TC warning checks on STI print preview.
     *
     * @return list<string>
     */
    public static function getStiTransactionWarningExcludes(): array
    {
        return ['voucher_type', 'posting_date', 'grand_total', 'matched_amt'];
    }

    /**
     * Bar item fields excluded from TC warning checks on STI print preview.
     *
     * @return list<string>
     */
    public static function getStiBarItemWarningExcludes(): array
    {
        return [
            'transaction_type',
            'quantity',
            'metal_name',
            'warehouse',
            'tx_amount',
            'spot_price',
            'posting_date',
            'exchange_rate',
            'item_code',
            'item_description',
            'fine_oz',
            'total_fine_oz',
            'gross_oz',
            'purity',
            'item_price',
            'unit_price',
            'premium_perc',
            'premium_final',
            'total_item_dc_amount',
            'serial_numbers',
            'weight',
            'bar_number',
            'other_charge',
            'narration',
            'long_desc',
            'metal_code',
            'remarks',
            'avg_spot_price',
            'currency',
        ];
    }
}
