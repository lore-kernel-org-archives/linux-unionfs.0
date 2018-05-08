Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755433AbeEHV5R (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 May 2018 17:57:17 -0400
Subject: Re: [PATCH 2/4] copy_file_range: Perform splice if in/out SB are not
 same
References: <20180508212405.15297-1-rgoldwyn@suse.de>
 <20180508212405.15297-3-rgoldwyn@suse.de>
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <a0ed27fb-c085-f1fc-733b-964db4ca20f4@redhat.com>
Date: Tue, 8 May 2018 23:57:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180508212405.15297-3-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 05/08/2018 11:24 PM, Goldwyn Rodrigues wrote:
> While performing copy_file_range(), if superblocks of file_in and
> file_out don't match, instead of returning -EXDEV, perform
> splice for a faster copy.

We have a userspace emulation in glibc which used to be quite faithful, 
including the EXDEV error (which is not strictly necessary to produce).

Should we change glibc to perform a userspace copy if the system call 
returns EXDEV due to an older kernel?

Thanks,
Florian
