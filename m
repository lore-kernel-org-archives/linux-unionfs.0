From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: copy new uid/gid into overlayfs runtime inode
Date: Thu, 3 Mar 2016 17:04:03 +0100
Message-ID: <CAJfpegvssUL0cq+PFzh69mTVVs7CJnqBWsRg+Oxo+Tzx5Gf1Vw@mail.gmail.com>
References: <145424648900.10573.4331586687947621230.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <145424648900.10573.4331586687947621230.stgit@zurg>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jan 31, 2016 at 2:21 PM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> Overlayfs must update uid/gid after chown, otherwise functions
> like inode_owner_or_capable() will check user against stale uid.
> Catched by xfstests generic/087, it chowns file and calls utimes.

Queued up patch.  Thanks.

Miklos
