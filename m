From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Sun, 10 Jun 2018 23:10:54 -0700
Message-ID: <20180611061054.GB8048@infradead.org>
References: <20180608121330.GG23785@veci.piliscsaba.redhat.com>
 <20180609065208.GA31572@infradead.org>
 <20180610055326.GR30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180610055326.GR30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jun 10, 2018 at 06:54:38AM +0100, Al Viro wrote:
> Umm...  The worst of yours had been ->pre_mmap(), right?  He *did* drop that...

Oh, hadn't notied that.  Still odd to change a huge pull request after
the end merge window.
