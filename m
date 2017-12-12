From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] unionmount-testsuite: Amir's master branch updated
Date: Tue, 12 Dec 2017 11:10:21 +1100
Message-ID: <20171212001021.GR4094@dastard>
References: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
 <20171206181700.GA7967@redhat.com>
 <CAOQ4uxhTWV=ZwDK2DQS2KYux7fufoz0sc7Sv+9dz59gnM1u8+w@mail.gmail.com>
 <CAOQ4uxjM6ZLcyU5-nQXz=T98kuhMrCJ+1df85-19QJQjrr7JiA@mail.gmail.com>
 <20171211195920.GA13399@redhat.com>
 <CAOQ4uxhb4yVTt29E0XFYY_OT_ubQ5w0Zgqojn=y7nH+XSZ90GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:57369 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750836AbdLLAKo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Dec 2017 19:10:44 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhb4yVTt29E0XFYY_OT_ubQ5w0Zgqojn=y7nH+XSZ90GA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, fstests <fstests@vger.kernel.org>, Chandan Rajendra <chandan@linux.vnet.ibm.com>

On Mon, Dec 11, 2017 at 10:47:15PM +0200, Amir Goldstein wrote:
> On Mon, Dec 11, 2017 at 9:59 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > - For the xfs reflink test, I am curious that why have you recommended
> >   to also enabled "rmapbt=1". Is is required for the tests?
> >
> 
> You cannot enable reflink=1 without it.

Yes you can. They are two different functions, used for completely
different things. They both landed at the same time, will end up
being fully supported at the same time, and probably get turned on
by default at the same time. But they are independent options...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
