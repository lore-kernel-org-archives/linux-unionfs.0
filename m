Return-Path: <SRS0=upMg=6V=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624FCC38A2A
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 May 2020 14:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A19C20643
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 May 2020 14:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgEGOuB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 May 2020 10:50:01 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42128 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726308AbgEGOuB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 May 2020 10:50:01 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 047Enm1P018360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 7 May 2020 10:49:48 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E37BA421C7D; Thu,  7 May 2020 10:49:47 -0400 (EDT)
Date:   Thu, 7 May 2020 10:49:47 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
        adilger@dilger.ca, riteshh@linux.ibm.com, amir73il@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: Re: fix fiemap for ext4 bitmap files (+ cleanups) v3
Message-ID: <20200507144947.GJ404484@mit.edu>
References: <20200505154324.3226743-1-hch@lst.de>
 <20200507062419.GA5766@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507062419.GA5766@lst.de>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, May 07, 2020 at 08:24:19AM +0200, Christoph Hellwig wrote:
> On Tue, May 05, 2020 at 05:43:13PM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > the first two patches should fix the issue where ext4 doesn't
> > properly check the max file size for bitmap files in fiemap.
> > 
> > The rest cleans up the fiemap support in ext4 and in general.
> 
> Folks, I think the first two patches should go into 5.7 to fix the
> ext4 vs overlay problem.  Ted, are you going to pick this up, or Al?

I'll pick up the two fixes, thanks.  Which tree are the rest of the
patches going to go through?

					- Ted
