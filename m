Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828638F66
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Jun 2024 01:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718242329; cv=none; b=P3TKfUrAXg4Xdr0i5MrdT+02B24ABLij/sCPf14d4t/eiqhBf8HvgZydsBBntcrtowIzfxLtEvowWzsSaD69FbqHctmARRgdKL494v/Oid1PaAHky0hJwIjxp1AKKM3A6jI8VIUT9i0Z3OXpSgV5r49DvK/ZppR1bI+Dk796UKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718242329; c=relaxed/simple;
	bh=DZMP6T9lSGzl7MljPCWTcSlSyBqw5NlexK09PxhQrD8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=UW4RKQMbCj7PFBMv0WVqkeqUUk6gd0QUecn6DNqY990FMLjbuXVzdz8pLqhEOskPX8xNDhf6SFFRk/upVJttB3+B2oEvOApGySsczyQR+Ywenir4V4mMoP7BDRprCiuqW+44bYr1T7kIF+vTiPiqYJf7Sl8pCKPTO8uccKj5x/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZRfVFwZ/; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZRfVFwZ/"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-62a08092c4dso5268137b3.0
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Jun 2024 18:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718242326; x=1718847126; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PDxO0u/+abLYEqmXq9B7oilXYyvM6dt2O+Y0Sq+reV8=;
        b=ZRfVFwZ/YbycRSoh2UqeL/3PLP25wOPA5Yr4ilMXqZGo2HpJgqT5wwGDLNiJOyAI8s
         BXn4RBAx39077bSsZQtmVKQsDCXDa+uDDKTKWa50LbNJwpU/KyMnbWvF9vhbbVV9kZOp
         5IqQh4/UpeEM5kogIyVgpWQ44Fhm53m1tiuHT4uO8b5bpVTynvaa1SpKc39XjYOmC+QO
         tkWYsMKQxZ22BAfCHwuEtzEyrBnQfMqXIcSrOk+XB3UYNgHSxK+XWFN9UrH9lg4jhkh6
         0R0JeEgmfiMm9T+skSBKA9HW1hD33/2TEoW1EQ3KlIBbxUAg0Y598IZLTQhk6p6CDUpp
         dJVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718242326; x=1718847126;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PDxO0u/+abLYEqmXq9B7oilXYyvM6dt2O+Y0Sq+reV8=;
        b=FltmBYmSl0EFGynkwL/4zTL/hKYJXh+ktc/TcHMR0jD7zLAetja9V3Mpc1y6Xm46gr
         iszV0B2+ecSfwDlIq16RmQzAWx1Uir6bnsFXX4/vnK/IHteh5sqbf9rROGSCn+txlwNc
         FS7azXvVO1a30p6bjx9P28FWIxxTDCmlayPpSnkalaLpFR3j11Aq9mWbqEUhfykg/yCO
         GD/wt8ar8MmnxphYmAjDWzA9JDyhPoYv5sNVjJ9KtR1YeoC5itEa5rMNKBWkN5TRQYlP
         XXbdvOQrBszD7WAevB435pNsaCl7WXOSt/n+ZamAovBahxsDSCnsR1qg3Q/pTtIVDhqT
         Occg==
X-Gm-Message-State: AOJu0YyQ4a6061mQ44YpLvtEN3GNL1kNielxjdNoK70plKVWnvctbA/y
	Wiw+VMHo8L895kNZ4OwpByiiNHvDotsd08ngtBV5D+210SXzSYYt3j2xesp3TZCpMSrxsh1QqlH
	1OD8yq1Hk9wFHY5+TGsmBWG104Lqnhe5z
X-Google-Smtp-Source: AGHT+IH3TaUGca3h42Wjf5ma8AqlFDeCcezEbo5wQgGp4uW0TfBm6rW5w/4GKQsfeaV5ue4CGUCUXAabI9ejTIGdOsw=
X-Received: by 2002:a81:6c50:0:b0:627:de70:f2f8 with SMTP id
 00721157ae682-62fb8862ac3mr31940077b3.14.1718242325778; Wed, 12 Jun 2024
 18:32:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Youzhong Yang <youzhong@gmail.com>
Date: Wed, 12 Jun 2024 21:31:55 -0400
Message-ID: <CADpNCvaBimi+zCYfRJHvCOhMih8OU0rmZkwLuh24MKKroRuT8Q@mail.gmail.com>
Subject: crash inside ovl_encode_real_fh() due to NULL dentry pointer
To: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I'd like to report an overlayfs related crash. The stack trace is as follows:

crash> bt
PID: 1789     TASK: ffff89006ebc5200  CPU: 57   COMMAND: "lsof"
 #0 [ffffc900b24b74e8] machine_kexec at ffffffff810afa90
 #1 [ffffc900b24b7558] __crash_kexec at ffffffff81219328
 #2 [ffffc900b24b7630] panic at ffffffff810f5b01
 #3 [ffffc900b24b76c0] oops_end at ffffffff81055835
 #4 [ffffc900b24b7708] page_fault_oops at ffffffff810c7a17
 #5 [ffffc900b24b7788] do_user_addr_fault at ffffffff810c84ae
 #6 [ffffc900b24b77f0] exc_page_fault at ffffffff82110102
 #7 [ffffc900b24b7830] asm_exc_page_fault at ffffffff82200c27
    [exception RIP: ovl_encode_real_fh+48]
    RIP: ffffffffc243dca0  RSP: ffffc900b24b78e0  RFLAGS: 00010282
    RAX: 0000000000000000  RBX: ffffc900b24b7a58  RCX: 0000000000000080
    RDX: 61c8864680b583eb  RSI: 0000000000000000  RDI: ffff890058bc9800
    RBP: ffffc900b24b7938   R8: 0000000000000002   R9: ffff890673f21ce0
    R10: 0000000000ffff10  R11: 000000000000000f  R12: 0000000000000001
    R13: ffff890058bc9800  R14: 0000000000000080  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #8 [ffffc900b24b7940] ovl_dentry_to_fid at ffffffffc24402b1 [overlay]
 #9 [ffffc900b24b79a0] ovl_encode_fh at ffffffffc2440435 [overlay]
#10 [ffffc900b24b79f8] exportfs_encode_inode_fh at ffffffff8165937b
#11 [ffffc900b24b7a38] show_mark_fhandle at ffffffff815208ec
#12 [ffffc900b24b7b08] inotify_fdinfo at ffffffff81520ca0
#13 [ffffc900b24b7b40] show_fdinfo at ffffffff81520a7f
#14 [ffffc900b24b7ba0] inotify_show_fdinfo at ffffffff81520cee
#15 [ffffc900b24b7bc0] seq_show at ffffffff81580d4c
#16 [ffffc900b24b7c18] seq_read_iter at ffffffff814f42a0
#17 [ffffc900b24b7c88] seq_read at ffffffff814f4713
#18 [ffffc900b24b7d48] vfs_read at ffffffff814ba791
#19 [ffffc900b24b7e10] ksys_read at ffffffff814bb7aa
#20 [ffffc900b24b7e70] __x64_sys_read at ffffffff814bb85e
#21 [ffffc900b24b7e90] x64_sys_call at ffffffff81006641
#22 [ffffc900b24b7eb0] do_syscall_64 at ffffffff82108b58
#23 [ffffc900b24b7f50] entry_SYSCALL_64_after_hwframe at ffffffff82200130
    RIP: 0000772a57dd2a61  RSP: 00007ffcc0ebd2a8  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: 000063e265d7a2a0  RCX: 0000772a57dd2a61
    RDX: 0000000000000400  RSI: 000063e265d7a500  RDI: 0000000000000007
    RBP: 00007ffcc0ebd2e0   R8: 0000000000000001   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000772a57eb9030
    R13: 0000772a57eb8ee0  R14: 0000000000000000  R15: 000063e265d7a2a0
    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b

I analyzed the crash dump, here is what I figured out:
- The overlay fs is mounted with only 2 lowerdirs, and nfs_export=on
- When ovl_dentry_to_fid() is called on the root dentry:
   - ovl_check_encode_origin(dentry) returns 0 as euc_lower (I believe
it should return 1 in this case)
   - "enc_lower ? ovl_dentry_lower(dentry) : ovl_dentry_upper(dentry)"
evaluates to NULL
   - NULL is passed as the second argument to ovl_encode_real_fh(), so
it crashes

This crash has been reproduced on both kernel 6.8 and 6.6, but I
haven't tried on any newer kernel version.
I have a simple C program to reproduce it, if needed I can upload its
source to my github repository or email it here.

Thanks,
-Youzhong
