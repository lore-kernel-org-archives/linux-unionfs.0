From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: Sync upper dirty data when sync overlayfs
Date: Tue, 28 Nov 2017 13:00:13 +0200
Message-ID: <CAOQ4uxhKSaUamDfyX49o41jH6v6751X8XxYegEmS=g7roGHM8Q@mail.gmail.com>
References: <1511844026-12765-1-git-send-email-cgxu@mykernel.net>
 <CAOQ4uxiL8vdkcTSGnqGKtH1AVaZ+W0LcaTaoi6mifGjhq48Ljg@mail.gmail.com>
 <0DEF5E95-D6C6-4F2C-9710-C4DC8BB14691@mykernel.net> <CAOQ4uxgbM_bFkm_hymvn6U2i+NZQG2LAqpH8XtTsduVLJXdHDQ@mail.gmail.com>
 <50026B1F-55D2-4352-8EAB-9DDA32F9BB4D@mykernel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:36387 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751254AbdK1LAP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 06:00:15 -0500
Received: by mail-yw0-f175.google.com with SMTP id g193so2835767ywe.3
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Nov 2017 03:00:14 -0800 (PST)
In-Reply-To: <50026B1F-55D2-4352-8EAB-9DDA32F9BB4D@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: cgxu <cgxu@mykernel.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Nov 28, 2017 at 11:27 AM, cgxu <cgxu@mykernel.net> wrote:
>
>> =E5=9C=A8 2017=E5=B9=B411=E6=9C=8828=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=88=
5:00=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=
=9A
>>
>> On Tue, Nov 28, 2017 at 10:18 AM, cgxu <cgxu@mykernel.net> wrote:
>>>
>> [...]
>>>> Unless I am missing something subtle here, you should export vfs
>>>> __sync_filesystem and call it from here instead of duplicating it.
>>>> Any technical reason not to do it?
>>>>
>>>
>>> Actually, not a technical reason. How about below modification?
>>> If it looks good I=E2=80=99ll send patch on new mail thread.
>>>
>>
>> Much better. See one nit below.
>> Why new mail thread? It is better if you send V3 patch with same subject
>> and change log since V2, so maintainer knows this patch supersedes
>> the previous one.
>>
>
> Thank you, got it.
> BTW, currently I use mainline tree, should I rebase on overlay-next? or o=
ther tree?
>

Current overlay-next is merged to master and your patch makes very
little changes
outside fs/overlayfs so the answer is it doesn't matter.
Usually you should rebase on overlay-next when posting a patch to overlayfs
maintainer.

Cheers,
Amir.
