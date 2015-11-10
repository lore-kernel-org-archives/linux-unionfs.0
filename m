From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: [PATCH] overlayfs: move super block magic number to magic.h
Date: Tue, 10 Nov 2015 17:13:07 +0100
Message-ID: <CAJfpegtE2SF+AeJs38XMytoLWqyn6B9x64RAvQdpPX8bs4LE3w@mail.gmail.com>
References: <20151104105952.7232543a@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151104105952.7232543a@xeon-e3>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Cc: Hannes Frederic Sowa <hannes-tFNcAqjVMyqKXQKiL6tip0B+6BGkLq7r@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Nov 4, 2015 at 7:59 PM, Stephen Hemminger
<stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org> wrote:
> The overlayfs file system is not recognized by programs
> like tail because the magic number is not in standard header location.
>
> Move it so that the value will propagate on for the GNU library
> and utilities. Needs to go in the fstatfs manual page as well.
>
> Signed-off-by: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>

Thanks, pushed to

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

Miklos
