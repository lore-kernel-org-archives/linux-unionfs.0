Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755620AbeEHV7s (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 May 2018 17:59:48 -0400
Subject: Re: [PATCH 3/4] copy_file_range: splice with holes
References: <20180508212405.15297-1-rgoldwyn@suse.de>
 <20180508212405.15297-4-rgoldwyn@suse.de>
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <12f4b7e0-209e-210b-f583-d76f6fd5a2d3@redhat.com>
Date: Tue, 8 May 2018 23:59:45 +0200
MIME-Version: 1.0
In-Reply-To: <20180508212405.15297-4-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 05/08/2018 11:24 PM, Goldwyn Rodrigues wrote:
> copy_file_range calls do_splice_direct() if fs->clone_file_range
> or fs->copy_file_range() is not available. However, do_splice_direct()
> converts holes to zeros. Detect holes in the file_in range, and
> create them in the corresponding file_out range.

Should this be restricted to calls to copy_file_range with a 
(yet-to-be-defined) flag?

I was under the impression that the hole-filling nature of 
copy_file_range was not a bug.

Thanks,
Florian
