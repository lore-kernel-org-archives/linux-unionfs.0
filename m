Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964945AbeEITNd (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 May 2018 15:13:33 -0400
Subject: Re: [PATCH 4/4] ovl: Use do_copy_file_range() in copy_up_data()
References: <20180508212405.15297-1-rgoldwyn@suse.de>
 <20180508212405.15297-5-rgoldwyn@suse.de>
 <CAOQ4uxhsjHjRy1hKwFyH7nkEE0Y_tv9sSh2dMLLwrVoM6fBeJw@mail.gmail.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <254dfd61-8c9a-9cc9-5f95-c0227eef484c@suse.de>
Date: Wed, 9 May 2018 14:13:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhsjHjRy1hKwFyH7nkEE0Y_tv9sSh2dMLLwrVoM6fBeJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>



On 05/09/2018 12:50 AM, Amir Goldstein wrote:
> On Wed, May 9, 2018 at 12:24 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> This will preserve the holes and will clone(), if available.
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> Only please mention in commit message that it changes behavoir
> slightly for a very large file (clone in chunks).

Change behavior? Only it will have holes. It will still respect length.
Actually, I found a bug when it would not respect length if offset is
father than length which I have fixed.

> I see no problem with this change.
> 
> And please test with xfstest overlay/001 with copies up a large
> sparse file. test time should drop from ~30s to 0s.

Yup, it passes in 1s on my VM :)

> If you like I can test that one for you.
> I believe there are also generic copy_file_range tests in xfstests.
> 

Thanks for the review

-- 
Goldwyn
