Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5326.1524667751@jrobl>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
 <1522333133-24772-7-git-send-email-amir73il@gmail.com> <5326.1524667751@jrobl>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 25 Apr 2018 08:00:36 -0700
Message-ID: <CAOQ4uxjMiVTuJsOreiV8PPbgq6S20WTTg13Gd+KSnoVxiHn4QQ@mail.gmail.com>
Subject: Re: [PATCH v9 6/7] ovl: add support for "xino" mount option
Content-Type: text/plain; charset="UTF-8"
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 25, 2018 at 7:49 AM, J. R. Okajima <hooanon05g@gmail.com> wrote:
> Amir Goldstein:
>> The mount option name "xino" goes after a similar meaning mount option
>> of aufs, but in overlayfs case, the mapping is stateless.
>
> The name "xino" is really confusing to me.
> I know what aufs xino is, and also understand what problem overlayfs
> wants to solve. For those who knows these two points,
> - the same name with totaly different implementation
> - very similar option usage
> is very bad.
>
> I never say that "xino" name is patented and only aufs can use it, but
> I'd ask you to change the name to help (future) users from confusing.
>

I certainly do not want to be confusing users, but why should users
care about implementation at all? Users that request a feature only
care about the outcome, which is persistent and consistent inode
numbers.

>From aufs documentation, 'xino' is described:
"Use external inode number bitmap and translation table"
The meaning of the feature is exactly the same in overlayfs
from user perspective, besides the fact that there is not actually
an external file to do the translation table. But that is a minor
technical detail that users should not be concerned with.

In my opinion, choosing the same name for the same outcome
is quite the opposite of confusing users.

Thanks,
Amir.
