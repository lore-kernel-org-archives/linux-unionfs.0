Return-Path: <rpjro@a01.itscom.net>
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH v9 6/7] ovl: add support for "xino" mount option
In-Reply-To: <CAOQ4uxjMiVTuJsOreiV8PPbgq6S20WTTg13Gd+KSnoVxiHn4QQ@mail.gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com> <1522333133-24772-7-git-send-email-amir73il@gmail.com> <5326.1524667751@jrobl> <CAOQ4uxjMiVTuJsOreiV8PPbgq6S20WTTg13Gd+KSnoVxiHn4QQ@mail.gmail.com>
Date: Thu, 26 Apr 2018 00:26:28 +0900
Message-ID: <10420.1524669988@jrobl>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Amir Goldstein:
> In my opinion, choosing the same name for the same outcome
> is quite the opposite of confusing users.

If the syntax (or the meaning) of the option was fully compatible, you
might be right.

- aufs: xino=<path> or noxino
- overlayfs: xino=on|off

I am afraid its confusing.


J. R. Okajima
