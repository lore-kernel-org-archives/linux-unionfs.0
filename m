Return-Path: <rpjro@a01.itscom.net>
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH v9 6/7] ovl: add support for "xino" mount option
In-Reply-To: <1522333133-24772-7-git-send-email-amir73il@gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com> <1522333133-24772-7-git-send-email-amir73il@gmail.com>
Date: Wed, 25 Apr 2018 23:49:11 +0900
Message-ID: <5326.1524667751@jrobl>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Amir Goldstein:
> The mount option name "xino" goes after a similar meaning mount option
> of aufs, but in overlayfs case, the mapping is stateless.

The name "xino" is really confusing to me.
I know what aufs xino is, and also understand what problem overlayfs
wants to solve. For those who knows these two points,
- the same name with totaly different implementation
- very similar option usage
is very bad.

I never say that "xino" name is patented and only aufs can use it, but
I'd ask you to change the name to help (future) users from confusing.


J. R. Okajima
