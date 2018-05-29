From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Tue, 29 May 2018 06:59:38 -0700
Message-ID: <20180529135938.GA5631@infradead.org>
References: <20180529132148.GC23785@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529132148.GC23785@veci.piliscsaba.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

>       vfs: add f_op->pre_mmap()

We've been through these pre-mmap games a few times, and always rejected
them, why is this any different?

>       vfs: export vfs_dedupe_file_range_one() to modules

Please use EXPORT_SYMBOL_GPL for all these crazy low-level exports.

To be homest I'd really like to see the whole thing as a patch series
instead of a pull request.  Very little seems to have gotten any
reviewed-by tags which makes me very suspicious.
