From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] readlink cleanup
Date: Sun, 11 Dec 2016 02:39:05 +0000
Message-ID: <20161211023902.GA24547@ZenIV.linux.org.uk>
References: <20161210204145.GK2622@veci.piliscsaba.szeredi.hu>
 <20161211023620.GL1555@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161211023620.GL1555@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Dec 11, 2016 at 02:36:20AM +0000, Al Viro wrote:

> I'm still not sure what does "vfs: convert ->readlink to same signature as
> ->get_link" buy us.  If anything, the result appears to be more complex -
> you make freeing that buffer delayed (and introduce a dynamically allocated
> buffer in one case that didn't use it)...

PS: everything prior to that point looks fine.
