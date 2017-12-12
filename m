From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [ANNOUNCE] unionmount-testsuite: Amir's master branch updated
Date: Tue, 12 Dec 2017 17:00:13 +0200
Message-ID: <CAOQ4uxjofQPP_28ai1t9SFU2BJxAMk=3LymASVPn2xP0s_SFUQ@mail.gmail.com>
References: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
 <20171206181700.GA7967@redhat.com> <CAOQ4uxhTWV=ZwDK2DQS2KYux7fufoz0sc7Sv+9dz59gnM1u8+w@mail.gmail.com>
 <CAOQ4uxjM6ZLcyU5-nQXz=T98kuhMrCJ+1df85-19QJQjrr7JiA@mail.gmail.com>
 <20171211195920.GA13399@redhat.com> <CAOQ4uxhb4yVTt29E0XFYY_OT_ubQ5w0Zgqojn=y7nH+XSZ90GA@mail.gmail.com>
 <20171212001021.GR4094@dastard> <20171212145328.GA1572@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:34369 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752760AbdLLPAO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 10:00:14 -0500
In-Reply-To: <20171212145328.GA1572@infradead.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, fstests <fstests@vger.kernel.org>, Chandan Rajendra <chandan@linux.vnet.ibm.com>

On Tue, Dec 12, 2017 at 4:53 PM, Christoph Hellwig <hch@infradead.org> wrote:
> I have a customer using only reflink.  And they probably want to keep
> it that way as rmap adds quite a lot of overhead.

OK. convinced. Updated wiki to set only reflink feature enabled:
https://github.com/amir73il/overlayfs/wiki/Overlayfs-testing#Download_and_build_xfsprogs_with_XFS_reflink_support

Thanks,
Amir.
