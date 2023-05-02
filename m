Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0CCC77B7C
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 May 2023 00:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbjEBAHl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 May 2023 20:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbjEBAHk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2023 20:07:40 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A992B35B8
        for <linux-unionfs@vger.kernel.org>; Mon,  1 May 2023 17:07:38 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64115e652eeso30720314b3a.0
        for <linux-unionfs@vger.kernel.org>; Mon, 01 May 2023 17:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682986058; x=1685578058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vPkxZmjvPrwj9yARID2IcnIbVYQzVlz9N1UD75yWJc=;
        b=0UfJ7TbcVUadFwEts5kOLmLB4BgJqrRqx9uD+f8LXaQJSMmqYqjD7Fh6Cfn0NPkJb/
         ioCuz2M50D37KKGuAxc3MgBQE2ral1pGfWy1jNpjDLvM9ZCCgB+c2Zhz2PHLQPL5X38Y
         zeDMAefPinLcV2aODW6pogWX34Wv3FCrk9tNqECSaF7Y4nuXeg9wsvn54WMT7OlCODv4
         X1KgshO5erNjMBVLeRz2u7QqdEqwDLsqF4E7mnzNIosJAuV7fqjKx7rpR4DdjwbO543q
         +aSxmH24oGdBCQHZ1Y/TFhJUSr73YFOl2Y75rLhVvUD1gf7zAFhVJ+UsP8aMwTsfzRib
         Plhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682986058; x=1685578058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8vPkxZmjvPrwj9yARID2IcnIbVYQzVlz9N1UD75yWJc=;
        b=VYPunXPcp2jGRGvA/5abKSz3+1Jhi4XijC295FvjAbCzXY2dfBUvb05FcxLsQd+GN6
         BfRbjRHUhcxHMgYTByS4soD0yGOuOn6QlR/f75BOKaATZUG09M3uvK7CpxmIv+WbuC9Y
         3UUuC7WdVO7Q64ENZKV1bWaHgf1NrhluFQY5mshvQ/wevymbfno2xdhxdupNOFoG2S+V
         vPeYRl5pJevPiK1+Kmm8VNG5dMGoNVwn2JBgOg+iYs1cPhCOdDdf0WzygJwXBpCmhCzh
         5oa7JxKautNAsiHOxSX52P8PsgHfkLYPlT7F52IAKjGeLTCtDXimijA9xFhxD5mojO/k
         v6Cg==
X-Gm-Message-State: AC+VfDw8A8F6nOqu4jNDSdMOqPNOI7a/HkqdtGdgNSo8W7v8WWbF/+cc
        3bswEwBTPz6xCZtN+P+s3FCvNHywXznYkTRCQpNgkw==
X-Google-Smtp-Source: ACHHUZ6xDNX4KW7bT3plKK/34ozRFT5NbHGd2w6rUaYtGnNHSc3WkI9OHAF7ScK8I3T2nZpmEkEIGyDN05ShjepR+/s=
X-Received: by 2002:a17:902:f7c5:b0:19e:2fb0:a5d9 with SMTP id
 h5-20020a170902f7c500b0019e2fb0a5d9mr17959310plw.32.1682986057925; Mon, 01
 May 2023 17:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230418014037.2412394-1-drosen@google.com> <CAJfpegtuNgbZfLiKnpzdEP0sNtCt=83NjGtBnmtvMaon2avv2w@mail.gmail.com>
In-Reply-To: <CAJfpegtuNgbZfLiKnpzdEP0sNtCt=83NjGtBnmtvMaon2avv2w@mail.gmail.com>
From:   Daniel Rosenberg <drosen@google.com>
Date:   Mon, 1 May 2023 17:07:26 -0700
Message-ID: <CA+PiJmTMs2u=J6ANYqHdGww5SoE_focZGjMRZk5WgoH8fVuCsA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v3 00/37] FUSE BPF: A Stacked Filesystem
 Extension for FUSE
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Joanne Koong <joannelkoong@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Apr 24, 2023 at 8:32=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
>
> The security model needs to be thought about and documented.  Think
> about this: the fuse server now delegates operations it would itself
> perform to the passthrough code in fuse.  The permissions that would
> have been checked in the context of the fuse server are now checked in
> the context of the task performing the operation.  The server may be
> able to bypass seccomp restrictions.  Files that are open on the
> backing filesystem are now hidden (e.g. lsof won't find these), which
> allows the server to obfuscate accesses to backing files.  Etc.
>
> These are not particularly worrying if the server is privileged, but
> fuse comes with the history of supporting unprivileged servers, so we
> should look at supporting passthrough with unprivileged servers as
> well.
>

This is on my todo list. My current plan is to grab the creds that the
daemon uses to respond to FUSE_INIT. That should keep behavior fairly
similar. I'm not sure if there are cases where the fuse server is
operating under multiple contexts.
I don't currently have a plan for exposing open files via lsof. Every
such file should relate to one that will show up though. I haven't dug
into how that's set up, but I'm open to suggestions.

> My other generic comment is that you should add justification for
> doing this in the first place.  I guess it's mainly performance.  So
> how performance can be won in real life cases?   It would also be good
> to measure the contribution of individual ops to that win.   Is there
> another reason for this besides performance?
>
> Thanks,
> Miklos

Our main concern with it is performance. We have some preliminary
numbers looking at the pure passthrough case. We've been testing using
a ramdrive on a somewhat slow machine, as that should highlight
differences more. We ran fio for sequential reads, and random
read/write. For sequential reads, we were seeing libfuse's
passthrough_hp take about a 50% hit, with fuse-bpf not being
detectably slower. For random read/write, we were seeing a roughly 90%
drop in performance from passthrough_hp, while fuse-bpf has about a 7%
drop in read and write speed. When we use a bpf that traces every
opcode, that performance hit increases to a roughly 1% drop in
sequential read performance, and a 20% drop in both read and write
performance for random read/write. We plan to make more complex bpf
examples, with fuse daemon equivalents to compare against.

We have not looked closely at the impact of individual opcodes yet.

There's also a potential ease of use for fuse-bpf. If you're
implementing a fuse daemon that is largely mirroring a backing
filesystem, you only need to write code for the differences in
behavior. For instance, say you want to remove image metadata like
location. You could give bpf information on what range of data is
metadata, and zero out that section without having to handle any other
operations.

 -Daniel
