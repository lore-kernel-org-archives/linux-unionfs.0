Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59403 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964943AbeEITId (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 May 2018 15:08:33 -0400
Subject: Re: [PATCH 2/4] copy_file_range: Perform splice if in/out SB are not
 same
References: <20180508212405.15297-1-rgoldwyn@suse.de>
 <20180508212405.15297-3-rgoldwyn@suse.de>
 <a0ed27fb-c085-f1fc-733b-964db4ca20f4@redhat.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <4afb2ef0-7cf9-a2c4-4ad8-d91f9ea3d3df@suse.de>
Date: Wed, 9 May 2018 14:08:27 -0500
MIME-Version: 1.0
In-Reply-To: <a0ed27fb-c085-f1fc-733b-964db4ca20f4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>, linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>



On 05/08/2018 04:57 PM, Florian Weimer wrote:
> On 05/08/2018 11:24 PM, Goldwyn Rodrigues wrote:
>> While performing copy_file_range(), if superblocks of file_in and
>> file_out don't match, instead of returning -EXDEV, perform
>> splice for a faster copy.
> 
> We have a userspace emulation in glibc which used to be quite faithful,
> including the EXDEV error (which is not strictly necessary to produce).
> 
> Should we change glibc to perform a userspace copy if the system call
> returns EXDEV due to an older kernel?
> 

I don't seen any purpose. The user would anyways have to perform a copy
if it receives -EXDEV.

-- 
Goldwyn
