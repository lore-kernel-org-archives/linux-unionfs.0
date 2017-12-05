From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH] ovl: don't follow redirects if redirect_dir=off
Date: Tue, 5 Dec 2017 16:18:06 +0100
Message-ID: <CAJfpegu=iwDMfmSig2TdQgmeq-0rqiMJGkUHeeEorvbFA7XpAA@mail.gmail.com>
References: <20171205133707.GA24303@veci.piliscsaba.redhat.com> <7051.1512484573@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:38520 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752777AbdLEPSH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Dec 2017 10:18:07 -0500
Received: by mail-qt0-f171.google.com with SMTP id d4so1491677qtj.5
        for <linux-unionfs@vger.kernel.org>; Tue, 05 Dec 2017 07:18:07 -0800 (PST)
In-Reply-To: <7051.1512484573@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Dec 5, 2017 at 3:36 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> +static const bool ovl_redirect_follow_def =
>> +     IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW);
>
> This would be better as a #def'd constant rather than a constant variable so
> that it can be used to optimise stuff away and so that it won't take up
> .rodata space.

Okay.

Thanks,
Miklos
