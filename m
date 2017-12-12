From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] unionmount-testsuite: Amir's master branch updated
Date: Tue, 12 Dec 2017 06:53:28 -0800
Message-ID: <20171212145328.GA1572@infradead.org>
References: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
 <20171206181700.GA7967@redhat.com>
 <CAOQ4uxhTWV=ZwDK2DQS2KYux7fufoz0sc7Sv+9dz59gnM1u8+w@mail.gmail.com>
 <CAOQ4uxjM6ZLcyU5-nQXz=T98kuhMrCJ+1df85-19QJQjrr7JiA@mail.gmail.com>
 <20171211195920.GA13399@redhat.com>
 <CAOQ4uxhb4yVTt29E0XFYY_OT_ubQ5w0Zgqojn=y7nH+XSZ90GA@mail.gmail.com>
 <20171212001021.GR4094@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52789 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752408AbdLLOxe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 09:53:34 -0500
Content-Disposition: inline
In-Reply-To: <20171212001021.GR4094@dastard>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, fstests <fstests@vger.kernel.org>, Chandan Rajendra <chandan@linux.vnet.ibm.com>

I have a customer using only reflink.  And they probably want to keep
it that way as rmap adds quite a lot of overhead.
