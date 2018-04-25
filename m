Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <10420.1524669988@jrobl>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
 <1522333133-24772-7-git-send-email-amir73il@gmail.com> <5326.1524667751@jrobl>
 <CAOQ4uxjMiVTuJsOreiV8PPbgq6S20WTTg13Gd+KSnoVxiHn4QQ@mail.gmail.com> <10420.1524669988@jrobl>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 25 Apr 2018 08:35:46 -0700
Message-ID: <CAOQ4uxhYkvqA8FdPBgwBwVsa2xeeFhV212CSSm81vFs8HT=8kA@mail.gmail.com>
Subject: Re: [PATCH v9 6/7] ovl: add support for "xino" mount option
Content-Type: text/plain; charset="UTF-8"
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 25, 2018 at 8:26 AM, J. R. Okajima <hooanon05g@gmail.com> wrote:
> Amir Goldstein:
>> In my opinion, choosing the same name for the same outcome
>> is quite the opposite of confusing users.
>
> If the syntax (or the meaning) of the option was fully compatible, you
> might be right.
>
> - aufs: xino=<path> or noxino
> - overlayfs: xino=on|off
>
> I am afraid its confusing.
>

Ok, let's see if users complain.
I have no objection to also support the syntax
xino/noxino in addition to xino=on|off|auto

It's up to Miklos.

Thanks,
Amir.
