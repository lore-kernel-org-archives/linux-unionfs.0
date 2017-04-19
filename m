From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/4] fstests: add helper _require_exportfs
Date: Wed, 19 Apr 2017 10:50:42 +0100
Message-ID: <9867.1492595442@warthog.procyon.org.uk>
References: <1492539444-25938-4-git-send-email-amir73il@gmail.com> <1492539444-25938-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1492539444-25938-4-git-send-email-amir73il@gmail.com>
Content-ID: <9866.1492595442.1@warthog.procyon.org.uk>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Amir Goldstein <amir73il@gmail.com> wrote:

> +# Does NFS export work on this fs?
> +_require_exportfs()

Don't forget to add it to doc/requirement-checking.txt!

David
