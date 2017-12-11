From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [ANNOUNCE] unionmount-testsuite: Amir's master branch updated
Date: Mon, 11 Dec 2017 15:59:12 -0500
Message-ID: <20171211205912.GD13399@redhat.com>
References: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
 <20171206181700.GA7967@redhat.com>
 <CAOQ4uxhTWV=ZwDK2DQS2KYux7fufoz0sc7Sv+9dz59gnM1u8+w@mail.gmail.com>
 <CAOQ4uxjM6ZLcyU5-nQXz=T98kuhMrCJ+1df85-19QJQjrr7JiA@mail.gmail.com>
 <20171211195920.GA13399@redhat.com>
 <CAOQ4uxhb4yVTt29E0XFYY_OT_ubQ5w0Zgqojn=y7nH+XSZ90GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48582 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbdLKU7N (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Dec 2017 15:59:13 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhb4yVTt29E0XFYY_OT_ubQ5w0Zgqojn=y7nH+XSZ90GA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, fstests <fstests@vger.kernel.org>, Chandan Rajendra <chandan@linux.vnet.ibm.com>

On Mon, Dec 11, 2017 at 10:47:15PM +0200, Amir Goldstein wrote:

[..]
> > - For the xfs reflink test, I am curious that why have you recommended
> >   to also enabled "rmapbt=1". Is is required for the tests?
> >
> 
> You cannot enable reflink=1 without it.

I could do that. Here is the xfs_info output which shows rmapbt=0 and
reflink=1.

# xfs_info /mnt/test-xfs
meta-data=/dev/mapper/test--union-lower_layer isize=512    agcount=4, agsize=327680 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=1310720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Vivek
