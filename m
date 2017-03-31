From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: A whiteout device shows up in a overlayfs root directory.
Date: Fri, 31 Mar 2017 11:34:56 +0300
Message-ID: <CAOQ4uxjfz_VzS45brX=jDQsn9nnsTukPF+C08XZ_A-cvAe-iMA@mail.gmail.com>
References: <CAL-1w2tNqdxB91Qg_SVsxsru9zhUpMmbWTkSf5nE3FbjozMjAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33944 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751733AbdCaIe6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Mar 2017 04:34:58 -0400
Received: by mail-io0-f171.google.com with SMTP id b140so35409437iof.1
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Mar 2017 01:34:57 -0700 (PDT)
In-Reply-To: <CAL-1w2tNqdxB91Qg_SVsxsru9zhUpMmbWTkSf5nE3FbjozMjAg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Rock Lee <rockdotlee@gmail.com>
Cc: linux-unionfs@vger.kernel.org

On Fri, Mar 31, 2017 at 5:52 AM, Rock Lee <rockdotlee@gmail.com> wrote:
> Hi, all:
> When I "ls" a overlayfs directory which has a whiteout device in it's upp=
er dir,
> and got a strange output like this (aaa is a whiteout in upper):
>
> [ETO test]# ll -i
>  ls: cannot access 'aaa': No such file or directory
> total 3
>      ? ?????????? ? ?    ?      ?            ? aaa
> 157633 drwxr-xr-x 1 root root  96 3=E6=9C=88  31 2017 hello
> 157634 drwxr-xr-x 2 root root  96 3=E6=9C=88  31 2017 open
> 157632 drwxr-xr-x 1 root root 128 3=E6=9C=88  29 04:54 ssh
>
> But if I use "tree" to list the files , there is no whiteout device in
> the test(overlayfs root dir).
> I got this output and it seems OK.
>
> [ETO usb]# tree
> .
> =E2=94=9C=E2=94=80=E2=94=80 lower
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 aaa
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 hello
> =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 uu
> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 ssh
> =E2=94=9C=E2=94=80=E2=94=80 test
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 hello
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 open
> =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 uu
> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 ssh
> =E2=94=82       =E2=94=9C=E2=94=80=E2=94=80 aaa
> =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 bbb
> =E2=94=9C=E2=94=80=E2=94=80 upper
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 aaa
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 hello
> =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 uu
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 open
> =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 uu
> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 ssh
> =E2=94=82       =E2=94=9C=E2=94=80=E2=94=80 aaa
> =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 bbb
>
>
> If I am correct, I think if the upper dir has a whitout, and the root
> directory of overlayfs
> should not see this WHITEOUT DEV nor the file in the lower dir with
> the same name.
> Is this a overlayfs bug ???

Yes. Could be a bug.
Please report it to the maintainer of the distro you are using, unless
you are seeing this bug on a mainline kernel?
