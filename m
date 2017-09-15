From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [experimental PATCH] ovl: get rid of d_real()
Date: Fri, 15 Sep 2017 15:07:34 +0100
Message-ID: <20170915140734.GY5426@ZenIV.linux.org.uk>
References: <20170915135805.GD19278@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:34322 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdIOOHh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Sep 2017 10:07:37 -0400
Content-Disposition: inline
In-Reply-To: <20170915135805.GD19278@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Sep 15, 2017 at 03:58:05PM +0200, Miklos Szeredi wrote:
> And here's the prototype.  Poof, d_real() is gone.
> 
> It definitely has got problems, but just maybe it can be made better than the
> current mess.  It *does* solve the ro-rw inconsistency for normal reads (not
> mmaps).

... and makes for mind-boggling amount of opening/closing the files on underlying
filesystem.  Doing that on sodding ->read_iter() is simply wrong.  And you are
using the wrong credentials for those opens, anyway - it should be creds of opener,
not reader.
