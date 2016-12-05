From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2] ovl: lockdep annotate of nested stacked overlayfs
 inode lock
Date: Mon, 5 Dec 2016 11:00:27 +0100
Message-ID: <CAJfpegvc4-5bmzBdvsWgucFqtR0ffhJjpjDYv3HqAJP8U5T4ZQ@mail.gmail.com>
References: <1480784286-27229-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1480784286-27229-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sat, Dec 3, 2016 at 5:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> @@ -528,6 +528,53 @@ static const struct file_operations ovl_file_operations = {
>         .open           = ovl_open,
>  };
>
> +/*
> + * It is possible to stack overlayfs instance on top of another
> + * overlayfs instance as lower layer. We need to annonate the
> + * stackable i_mutex locks according to stack level of the super
> + * block instance. An overlayfs instance can never be in stack
> + * depth 0 (there is always a real fs below it).
> + * An overlayfs instance that is not stacked over another
> + * overlayfs will use lockdep annotation name 'ovl_i_mutex_key'.
> + * An overlayfs instance that is stacked over another overlayfs
> + * will use the lockdep annotaion name ovl_i_mutex_key[nested].
> + *
> + * Note that the address ovl_i_mutex_key is the same as the address of
> + * &ovl_i_mutex_key[0], but we use the former expression to annotate
> + * the inode lock in nesting level 0 to get a nicer looking lockdep
> + * chain annotation. For example, here is a snip from

Lockdep is good, but I think we shouldn't be adding complexity into
ovl_fill_super() just for the sake of a nice looking lockdep, it's
complex enough as it is.

This patch should add a single, self contained and as simple as
possible ovl_lockdep_annotate_inode_mutex_key() function. And it
should compile away to nothing when lockdep is not enabled.

Nice looking lockdep can be a secondary goal if it doesn't complicate
the implementation.

Thanks,
Miklos
