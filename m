From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/2] vfs: add file_path() helper
Date: Fri, 19 Jun 2015 09:38:16 +0100
Message-ID: <5410.1434703096@warthog.procyon.org.uk>
References: <20150619082913.GB24181@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150619082913.GB24181@tucsk>
Content-ID: <5409.1434703096.1@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Turn
> 	d_path(&file->f_path, ...);
> into
> 	file_path(file, ...);
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Acked-by: David Howells <dhowells@redhat.com>
