Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E2325B311
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 14:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766501345; cv=none; b=uWeXifLKgu6zdtkASTlTLA8+7jVmmMKbftjqkuIzvWVvM9W1rttMEQ2RFzHAWdIFkmPiiBfCLkzz7WuqQiy/dJP0np0AjBR/19uJWcqmhKf9e4JWu5l5L8rmgjyMfA8P5NlV0c3Fk+Je51f39excZaEcLJiuPmTFRwb6nfsHM98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766501345; c=relaxed/simple;
	bh=ufSnxcyP8EQ3M5HUHlTgXBfSdwRRBuJgHdT4xDWQ/W0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hXn56RhQJJIuMZ1e2FBR2fqwjDAnyimVny0+hf/tY3qDYcueqULHgPkRIcvTETzylEsor0VwCrwORMhjGnWf1gRm2WSSMt3rllp7R/c7bRx5/ivQKey6oo0ZWQBVE/iY674rrASZx8BeSVmRa3dra/9RV8c4OfIhdTDJctgXybk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YtcTCvEJ; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YtcTCvEJ"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64d4d8b3ad7so3295575a12.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 06:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766501342; x=1767106142; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JFfROU2c7Qq+368iXNodvvI4Bi1Q7qmgRcOhzYiDkmE=;
        b=YtcTCvEJkrCE8TYS+tQS2AeHaz3/GxJzL+jeCaqsMgZ3WBlA1g6bIM1BpTQ6POzQJs
         /iqp3teHvI6KDdDixBhKSgW9b9O+H0Lu/rAci6fLa4SWWrY8KUIRnlIX4mdfX8UXUXuY
         J+GpimC21/7KVD6mJZO61C9AOsoZ7hOpb2Q9d+f80v28yHtVJmLuhag0ysubs0fK7tw5
         86jR+IzeUHShh+xV54MjEvzVasplY4PzqNDI59GGAwuBXkmbdJED5eDFWaO0UpphzP39
         XgdJISJudS7tWlV2VJS5szsoKHoQmMaRO8minL3fPBFj/eJ0Yo3pZAKMm0lBJcvbCkBt
         D8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766501342; x=1767106142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JFfROU2c7Qq+368iXNodvvI4Bi1Q7qmgRcOhzYiDkmE=;
        b=SbXc+bsoAeiBo5s/6KAhojECbLjvoS27fOll5g9y890EFZoiGFhsIY4Y29ySyfW2DM
         iTMZ0Olhb6NVhDuhvInaiHsaImtScM9pI4WOQejtImWOiO6slfz5sOOpeX4A6686Oeye
         JgNG9NIiBcRtqgV3riFVNLEmOCMwkoG9IxUWkCASmS6fh09kENbp+UOQ8rM+/+Rq97Yi
         ctz9UscdQQYh0CCCx5rCzyW2vlxSfGaxKNSz1EsTDo8EWGk4cVkKyB8TwKZkNwwpTSWs
         bMUV3XAc3e9jQk523p7AYhseKNRYR8xeHnyxHZusr2cgxBMaMWDv/iJdyH1razj6bkvG
         q2Iw==
X-Gm-Message-State: AOJu0YxaIavF5ZmKMQDYPrcVM+prrUGkrpwEmbmyc4iUtiE9TPSORo73
	etSm1wJhDue0mpS7x+9mhAD+jHcVMO6gg6ldnXmqDvIDncxUyTpEGrHib1IWqcR5PpYJYYOyB4r
	+CZCCG67ebbhs20caGbyEQyCV2m5U6GI=
X-Gm-Gg: AY/fxX5dj2vosczeP9bm2iXIgsJMFKls5H8Wt2s2i5iZX55EfASubyoCzkvY/ssg3lH
	CwQnQ14bJ0GGTw6nSrr/neuptBLZeOeJPAb0Mg137YmGblgobT5ruiKbxfbx2qB+eZMBSZycK23
	v47sKGlsEkQxhlHAwftk7gVZl5/vqtkbuipczFPW1qvx3ZeC2qHGCIElcTcYtVq+Vh6FpQo7MoC
	moPOPairYlg5vp8QTMMGKn1Q+A1oOo7dmkcbcc4vVV3Gab88qPNjQgH9u51zq84p4WRwsWCQ23Y
	M0f5YKTZ/07JVTJTZn4Ve4oCcy5wOzMVWGVNiZvE
X-Google-Smtp-Source: AGHT+IHuG4Zlty0EBY8cSlYcxfsFprBgXJUV1JABoiLxrZSBt9aqmgn78+Moy6YnKpfKdeTiIVEtCIBURTefrpkDT6c=
X-Received: by 2002:a05:6402:350e:b0:64b:6271:4e1e with SMTP id
 4fb4d7f45d1cf-64b8ec6a5abmr14975028a12.17.1766501341335; Tue, 23 Dec 2025
 06:49:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGzaKqnw+218VAa_L-XfzcrzivV31R-OdAO1xjAT1p_Boi94dg@mail.gmail.com>
In-Reply-To: <CAGzaKqnw+218VAa_L-XfzcrzivV31R-OdAO1xjAT1p_Boi94dg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 23 Dec 2025 15:48:50 +0100
X-Gm-Features: AQt7F2rgYvQriINDbMIOLXV5v6UkW93ByYRMm5lGx4qb6_3NEkWXdvCpPojfviY
Message-ID: <CAOQ4uxi505WQB1E1dSYXcVGf9b5=HT-Cz55FMNw5RxnE=ww2yA@mail.gmail.com>
Subject: Re: overlay unionmount failed when a long path is set
To: Kun Wang <kunwan@redhat.com>, Christian Brauner <brauner@kernel.org>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Zirong Lang <zlang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2025 at 3:25=E2=80=AFPM Kun Wang <kunwan@redhat.com> wrote:
>
> Hi,
>
> This issue was found when I was doing overlayfs test on RHEL10 using unio=
nmount-test-suite. Confirmed upstream kernel got the same problem after doi=
ng the same test on the latest version with latest xfstests and unionmount-=
testsuite.
> [root@dell-per660-12-vm-01 xfstests]# uname -r
> 6.19.0-rc2+
>
> This issue only occurs when new mount API is on, some test cases in union=
mount test-suite start to fail like below after I set a long-name(longer th=
an 12 characters)  test dir:
>
> [root@dell-per660 xfstests]# ./check -overlay overlay/103
> FSTYP         -- overlay
> PLATFORM      -- Linux/x86_64 dell-per660-12-vm-01 6.19.0-rc2+ #1 SMP PRE=
EMPT_DYNAMIC Tue Dec 23 03:56:43 EST 2025
> MKFS_OPTIONS  -- /123456789abc
> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /123456789abc /=
123456789abc/ovl-mnt
>
> overlay/103        - output mismatch (see /root/xfstests/results//overlay=
/103.out.bad)
>     --- tests/overlay/103.out   2025-12-23 05:30:37.467387962 -0500
>     +++ /root/xfstests/results//overlay/103.out.bad     2025-12-23 05:44:=
53.414195538 -0500
>     @@ -1,2 +1,17 @@
>      QA output created by 103
>     +mount: /123456789abc/union/m: wrong fs type, bad option, bad superbl=
ock on overlay, missing codepage or helper program, or other error.
>     +       dmesg(1) may have more information after failed mount system =
call.
>     +Traceback (most recent call last):
>     +  File "/root/unionmount-testsuite/./run", line 362, in <module>
>     +    func(ctx)
>     +  File "/root/unionmount-testsuite/tests/rename-file.py", line 96, i=
n subtest_7
>     ...
>     (Run 'diff -u /root/xfstests/tests/overlay/103.out /root/xfstests/res=
ults//overlay/103.out.bad'  to see the entire diff)
> Ran: overlay/103
> Failures: overlay/103
> Failed 1 of 1 tests
>
> So I looked into unionmount-testsuite, and picked out the cmdline reprodu=
cer for this issue:
>
> //make a long name test dir and multiple lower later dir init//
> [root@dell-per660 xfstests]# mkdir -p /123456789abcdefgh/l{0..11}
> [root@dell-per660 xfstests]# mkdir /123456789abcdefgh/u /123456789abcdefg=
h/m /123456789abcdefgh/w
> [root@dell-per660 xfstests]# ls /123456789abcdefgh/
> l0  l1  l10  l11   l2  l3  l4  l5  l6  l7  l8  l9  m  u  w
>
> //do overlay unionmount with below cmd will tigger the issue://
> [root@dell-per660 xfstests]# mount -t overlay overlay /123456789abcdefgh/=
m -orw,index=3Don,redirect_dir=3Don -olowerdir=3D/123456789abcdefgh/l1:/123=
456789abcdefgh/l2:/123456789abcdefgh/l3:/123456789abcdefgh/l4:/123456789abc=
defgh/l5:/123456789abcdefgh/l6:/123456789abcdefgh/l7:/123456789abcdefgh/l8:=
/123456789abcdefgh/l9:/123456789abcdefgh/l10:/123456789abcdefgh/l11:/123456=
789abcdefgh/l0,upperdir=3D/123456789abcdefgh/u,workdir=3D/123456789abcdefgh=
/w
>
> mount: /123456789abcdefgh/m: wrong fs type, bad option, bad superblock on=
 overlay, missing codepage or helper program, or other error.
>        dmesg(1) may have more information after failed mount system call.
>
> //If I reduce the length of test dir name by 1 character, the mount will =
success://
> [root@dell-per660 xfstests]# cp /123456789abcdefgh /123456789abcdefg -r
> [root@dell-per660 xfstests]# mount -t overlay overlay /123456789abcdefg/m=
 -orw,index=3Don,redirect_dir=3Don -olowerdir=3D/123456789abcdefg/l1:/12345=
6789abcdefg/l2:/123456789abcdefg/l3:/123456789abcdefg/l4:/123456789abcdefg/=
l5:/123456789abcdefg/l6:/123456789abcdefg/l7:/123456789abcdefg/l8:/12345678=
9abcdefg/l9:/123456789abcdefg/l10:/123456789abcdefg/l11:/123456789abcdefg/l=
0,upperdir=3D/123456789abcdefg/u,workdir=3D/123456789abcdefg/w
> [root@dell-per660 xfstests]# df -h | grep overlay
> overlay          57G   29G   28G  52% /123456789abcdefg/m
>
>  //If force using mount2 api, the mount will be good too://
> [root@dell-per660 xfstests]# export LIBMOUNT_FORCE_MOUNT2=3Dalways
> [root@dell-per660 xfstests]# mount -t overlay overlay /123456789abcdefgh/=
m -orw,index=3Don,redirect_dir=3Don -olowerdir=3D/123456789abcdefgh/l1:/123=
456789abcdefgh/l2:/123456789abcdefgh/l3:/123456789abcdefgh/l4:/123456789abc=
defgh/l5:/123456789abcdefgh/l6:/123456789abcdefgh/l7:/123456789abcdefgh/l8:=
/123456789abcdefgh/l9:/123456789abcdefgh/l10:/123456789abcdefgh/l11:/123456=
789abcdefgh/l0,upperdir=3D/123456789abcdefgh/u,workdir=3D/123456789abcdefgh=
/w
> [root@dell-per660 xfstests]# df -h | grep overlay
> overlay          57G   29G   28G  52% /123456789abcdefg/m
> overlay          57G   29G   28G  52% /123456789abcdefgh/m
>
> So I don't think this unionmount cmd had reached the limit of param lengt=
h, since it's working with the old mount API.
> Then maybe a kernel bug needs to be fixed..

Hi Kun,

Thanks for reporting this issue.

We've had several issues with systems that are upgraded to linmount
that uses new mount API by default.

FYI, the lowerdir+ mount option was added exactly to avoid these sorts
of limits, but that will require changing applications (like unionmount
testsuite) to use this more scalable mount options or require libmount
to automatically parse and convert a long lowerdir=3D mount option to
smaller lowerdir+=3D mount options.

Christian,

Do you remember seeing this phenomenon when working on the new mount API?
I might have known about it and forgot...

Thanks,
Amir.
