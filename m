Return-Path: <SRS0=h8cR=6T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB2CC47247
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 10:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03D1220721
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 10:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgEEK3R (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 5 May 2020 06:29:17 -0400
Received: from verein.lst.de ([213.95.11.211]:34546 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgEEK3R (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 May 2020 06:29:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 518BB68C4E; Tue,  5 May 2020 12:29:14 +0200 (CEST)
Date:   Tue, 5 May 2020 12:29:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        viro@zeniv.linux.org.uk, jack@suse.cz, tytso@mit.edu,
        adilger@dilger.ca, amir73il@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 07/11] iomap: fix the iomap_fiemap prototype
Message-ID: <20200505102914.GA15815@lst.de>
References: <20200427181957.1606257-1-hch@lst.de> <20200427181957.1606257-8-hch@lst.de> <20200501233402.5101BAE045@d06av26.portsmouth.uk.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501233402.5101BAE045@d06av26.portsmouth.uk.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 02, 2020 at 05:04:01AM +0530, Ritesh Harjani wrote:
>
>
> On 4/27/20 11:49 PM, Christoph Hellwig wrote:
>> iomap_fiemap should take u64 start and len arguments, just like the
>> ->fiemap prototype.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> hmm.. I guess,
> it's only ->fiemap ops in inode_operations which has
> start and len arguments as u64.
>
> While such other ops in struct file_operations have the
> arguments of type loff_t. (e.g. ->fallocate, -->llseek etc).
>
> But sure to match the ->fiemap prototype, this patch looks ok to me.

Yes, fiemap is rather weird here, but it matches the ioctl prototype,
so I'd rather pass it on to the method where fiemap_prep will catch
anything that overflows s_maxbytes due to the signeness of loff_t.
