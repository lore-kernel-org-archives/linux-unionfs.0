From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] vfs: make open_with_fake_path() not contribute to nr_files
Date: Thu, 19 Jul 2018 16:52:44 +0100
Message-ID: <30900.1532015564@warthog.procyon.org.uk>
References: <CAJfpegvJOXo-e5swL5iNgiyGOQHT3viz86+NMAe1zvOC0Qwaig@mail.gmail.com> <20180718154637.31878-1-mszeredi@redhat.com> <18289.1531987758@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegvJOXo-e5swL5iNgiyGOQHT3viz86+NMAe1zvOC0Qwaig@mail.gmail.com>
Content-ID: <30899.1532015564.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Miklos Szeredi <mszeredi@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-unionfs@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> What the cachefiles use case would be?

Cachfiles has to open the backing file so that it can write to it, and it has
to do it every time it writes because to leave a bunch of files open
contributes to ENFILE/EMFILE.

In the near future it's going to have to open the backing file so that it can
read from it too as I need to switch to using the io context stuff and get rid
of my usage of bmap().

So it would be convenient to be able to keep the open backing file around for
longer to avoid constantly needing to open/close it.

David
