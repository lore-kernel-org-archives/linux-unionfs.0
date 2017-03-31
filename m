From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: A whiteout device shows up in a overlayfs root directory.
Date: Fri, 31 Mar 2017 13:26:07 +0300
Message-ID: <CAOQ4uxjtwBBnWA99_v+D2Y6eAikNvVQYG27qi3DjBTbLeE_1PA@mail.gmail.com>
References: <CAL-1w2tNqdxB91Qg_SVsxsru9zhUpMmbWTkSf5nE3FbjozMjAg@mail.gmail.com>
 <CAOQ4uxjfz_VzS45brX=jDQsn9nnsTukPF+C08XZ_A-cvAe-iMA@mail.gmail.com>
 <CAL-1w2tczyrFVRYeJnBjKc8XRbXH5NuoATXgAJAUpEJ4BALtyw@mail.gmail.com> <CAL-1w2tiKrrMiw9Hu2wC_m_=gr=tbbJnD3mz0BTuSJbiM_wPhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:34941 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932618AbdCaK0J (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Mar 2017 06:26:09 -0400
Received: by mail-io0-f178.google.com with SMTP id z13so36844465iof.2
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Mar 2017 03:26:08 -0700 (PDT)
In-Reply-To: <CAL-1w2tiKrrMiw9Hu2wC_m_=gr=tbbJnD3mz0BTuSJbiM_wPhA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Rock Lee <rockdotlee@gmail.com>
Cc: linux-unionfs@vger.kernel.org

On Fri, Mar 31, 2017 at 12:13 PM, Rock Lee <rockdotlee@gmail.com> wrote:
>
> Yes, I am using archlinux with mainline kernel linux-4.11.0-r3.
> This problem occurs when I am using minix fs as a underlying
> filesystem( which contains upperdir, lowerdir, workdir)
> But If I am using a ext4 filesystem as  a underlying filesystem, there
> is no such problem.
>
> I am wondering if the minix fs doesn't supper whiteout device.

The minix fs does not support d_type in readdir and file systems
that don't support d_type expose whiteouts to overlay.

See warning in dmesg:
"overlayfs: upper fs needs to support d_type."

>
> On Fri, Mar 31, 2017 at 5:10 PM, Rock Lee <rockdotlee@gmail.com> wrote:
>> Yes, I am using archlinux with mainline kernel linux-4.11.0-r3.
>> This problem occurs when I am using minix fs as a underlying filesystem.
>> But If I
>>
>> On Fri, Mar 31, 2017 at 4:34 PM, Amir Goldstein <amir73il@gmail.com> wro=
te:
>>> On Fri, Mar 31, 2017 at 5:52 AM, Rock Lee <rockdotlee@gmail.com> wrote:
>>>> Hi, all:
>>>> When I "ls" a overlayfs directory which has a whiteout device in it's =
upper dir,
>>>> and got a strange output like this (aaa is a whiteout in upper):
>>>>
>>>> [ETO test]# ll -i
>>>>  ls: cannot access 'aaa': No such file or directory
>>>> total 3
>>>>      ? ?????????? ? ?    ?      ?            ? aaa
>>>> 157633 drwxr-xr-x 1 root root  96 3=E6=9C=88  31 2017 hello
>>>> 157634 drwxr-xr-x 2 root root  96 3=E6=9C=88  31 2017 open
>>>> 157632 drwxr-xr-x 1 root root 128 3=E6=9C=88  29 04:54 ssh
>>>>
>>>> But if I use "tree" to list the files , there is no whiteout device in
>>>> the test(overlayfs root dir).
>>>> I got this output and it seems OK.
>>>>
>>>> [ETO usb]# tree
>>>> .
>>>> =E2=94=9C=E2=94=80=E2=94=80 lower
>>>> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 aaa
>>>> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 hello
>>>> =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 uu
>>>> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 ssh
>>>> =E2=94=9C=E2=94=80=E2=94=80 test
>>>> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 hello
>>>> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 open
>>>> =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 uu
>>>> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 ssh
>>>> =E2=94=82       =E2=94=9C=E2=94=80=E2=94=80 aaa
>>>> =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 bbb
>>>> =E2=94=9C=E2=94=80=E2=94=80 upper
>>>> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 aaa
>>>> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 hello
>>>> =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 uu
>>>> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 open
>>>> =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 uu
>>>> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 ssh
>>>> =E2=94=82       =E2=94=9C=E2=94=80=E2=94=80 aaa
>>>> =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 bbb
>>>>
>>>>
>>>> If I am correct, I think if the upper dir has a whitout, and the root
>>>> directory of overlayfs
>>>> should not see this WHITEOUT DEV nor the file in the lower dir with
>>>> the same name.
>>>> Is this a overlayfs bug ???
>>>
>>> Yes. Could be a bug.
>>> Please report it to the maintainer of the distro you are using, unless
>>> you are seeing this bug on a mainline kernel?
