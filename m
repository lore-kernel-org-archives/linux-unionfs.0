From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmpfs: generate random sb->s_uuid
Date: Tue, 9 May 2017 02:02:16 -0700
Message-ID: <20170509090216.GA28421@infradead.org>
References: <1493977468-21143-1-git-send-email-amir73il@gmail.com>
 <20170505100126.GA20759@infradead.org>
 <CAOQ4uxj7mtowTij45_Zh8ixhbNARxZG+YQ_UmHuoVR6AFTPHGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47734 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdEIJCS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 May 2017 05:02:18 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj7mtowTij45_Zh8ixhbNARxZG+YQ_UmHuoVR6AFTPHGg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>

On Fri, May 05, 2017 at 01:20:11PM +0300, Amir Goldstein wrote:
> Seriously, one has to do things in certain order.

Yes… and I want to ensure that order.

> There is no reason to wait for the common uuid code to settle down before
> fixing something as trivial as this and it makes very little sense IMO to use
> uuid_be_gen() for sb->s_uuid as it is now.

There is.  generate_random_uuid needs to die, and adding more callers
isn't the way to go.  Same for ubifs btw.
