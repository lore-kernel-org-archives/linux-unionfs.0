From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 2/2] ovl: get exclusive ownership on upper/work dirs
Date: Wed, 31 May 2017 15:24:05 +0200
Message-ID: <CAJfpegt8KnRf=Sj7pKp-4gUetJj_ZibS9vhYABTQjJ8mY5Pe8A@mail.gmail.com>
References: <1495533033-22367-1-git-send-email-amir73il@gmail.com>
 <1495533033-22367-3-git-send-email-amir73il@gmail.com> <CAJfpegsZWjPhJA==FF7YAw0XtCyhVcn1YtuPep+od6h8f=0DOA@mail.gmail.com>
 <CAOQ4uxidR+Rua_GatJK=WR7Yk=UiD9j8ygT+4BG_w=BYcP1u3Q@mail.gmail.com> <CAOQ4uxhFCsFECtbof50Xq9nouR8vooUknOzOGvVzG_q7oyx5NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35588 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdEaNYG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 May 2017 09:24:06 -0400
Received: by mail-oi0-f44.google.com with SMTP id l18so14919601oig.2
        for <linux-unionfs@vger.kernel.org>; Wed, 31 May 2017 06:24:06 -0700 (PDT)
In-Reply-To: <CAOQ4uxhFCsFECtbof50Xq9nouR8vooUknOzOGvVzG_q7oyx5NQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, May 31, 2017 at 3:05 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> Are you suggesting to move the inuse lock to the workdir inode? doable.
> I guess I choose to lock workdir/work because of the may_delete
> protection it provides,
> but you questioned that part anyway.

Yes, I think we should protect workdir/upperdir with I_INUSE.

> I don't mind dropping the "?" though - perhaps phrase the error more
> generically:
>     pr_err("overlayfs: workdir is in-use by another mount\n");

Okay.

Thanks,
Miklos
