Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE5947D93B
	for <linux-unionfs@vger.kernel.org>; Fri, 11 Sep 2026 12:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789131423; cv=pass; b=GTi+fLA/Ky3DLkJjgZsiugr3ckCyscemCWoDLlDxC5HLxikxH1kEJPxcBJhwtOXBf5k4itTwSWEjVAnP1Te4nCXO72tT5ordp6l24VinxwG7mr8ZrKpCfeNTegGj7xB9rC9dR0VPdlU6glz/L6zgq9iu7suF8xmabOMxPzgUelI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789131423; c=relaxed/simple;
	bh=FTjPJWgL7azmAVy/OhPs3LK4Og01sRmEWqKMEysRtLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tPQ3xvMZrDTg+pg9bWInhEenCNcEdaBWbgUNNqKJJyrrZ3jJBmjVL7/X+tvEEqTrrb7OSPwXmGRDgXst1TJO25YrIQK6Bm61Gt3UC2Tau5hSTh6uOU/hnJPbUMBpaqsp9oaWGuY319ct7IcRiEqOwfK7MG0nEzssf2UMVjmv+J0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oya9cpjm; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oya9cpjm"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-69fab5a852cso1369970a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Sep 2026 05:56:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789131406; cv=none;
        d=google.com; s=arc-20260327;
        b=TeDo/k/dtJLvkBTayR8FCAl+TMe/FMq97pB70t547BopDMwbaIvWMVHlW1j6bEyYCU
         iNAfcaTIfrCEA5qLDXBTS7QXPyIbkIloCWfVqSmi0BRPMeg9acaz9LR7NImce4bThId8
         fT551RVuU965QkruGTHA9dz+lEnbhS1LYvDucUrrD6Db3HrxTSLjBd4o29AkkYkLzixF
         Y42qtcFGSKUU0UKzsgssnxbZ9LFeVW8xgChrhXV7LrBFVweeYEf2kq8ti0kJ/xj7JjcQ
         ctD+KNMGNyNQ0EPP9Y5fxMBOcrl6S+rbvtjLQT79Vv4sFtBPIM5jo0cRQsJfuzInuAlE
         f7ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FAN04AozBS+qD8ZJjFEC9wp5PTlWL5yGKkFxUyo/YfU=;
        fh=zrErnhN+tgydk+MT0HUgzDSkxlOpMxEV1jqmQN5I7Iw=;
        b=eu24ovKL4o0hk0y2okhN7QW0ElyBovZrBuNhWzNBCZmadq0NafhEMwVtmVwXBuTY3Z
         d3z7OdrGyAHO5k3CKSvEM6FzNoHI+wmvOQKBM2zqLCWRA5wMLNirL4jWPUktdWvcXPxB
         p36P3FPFlmd7zVc6i8IWfZ+ANZAnqMn44DDLQBuV9Y+eURkhAfzfNaxZy/oIH3OxqMUU
         Doe2Ugt77yT4YOWSwed6UcnCHQpSsqK4HHkz0KcYoOVAJmEf9N6LC3gtBXMnnuX6K/p/
         w7kRMANhdHIpUobQTgTAw/ukWVUy7RWvFFE855tbJRSh9OYP+agY//B6xjEUW0xhcLAz
         SW0A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789131406; x=1789736206; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FAN04AozBS+qD8ZJjFEC9wp5PTlWL5yGKkFxUyo/YfU=;
        b=Oya9cpjmtM+nLHaVl7NSNVmFTK80hvI5nDfcU/ntGbwWnvy3mlFNotrYspWNguHqfn
         QlJjew6bRfwrCcCEcaXAzk/wNjAmY8NCZmzrQpnXqM6OuL1bGNje481v9Aq9WrYiizWa
         losvroAhARdzJOOTRJHFOuYNibABmiy3/4ee9T4d6Bkj84XW1tUnLAWI7NU4i96Y5Qkf
         qTOtGv7KqlDBZYLX2rUmgAp3MvXnNB8khxbZWcZrbGR/zXL+S+g+LpJvtlNK3PYdfTHv
         gigYLLRB0h8glu7xpikGx/9+yk23e3ErAoys0iLDoGpoPXNRkkkFse8fx7w6xN5Q3aHH
         GuPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789131406; x=1789736206;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FAN04AozBS+qD8ZJjFEC9wp5PTlWL5yGKkFxUyo/YfU=;
        b=R1O09Yek/15Ba8b6b8Lg3TII6Ti9gaoOb63BxmQ61cLnAK/pvSvq/UCdrPrniosGdm
         oYAFLAIaAjz74snRfMpxV60rhh3EIBFd2ICdwrlYShvfXEmjD6GCwetkrI12o7yLP5mZ
         BB4YA+PeyXTDbxzptn2qaebux2DhN7c3NdeUE0WkBaTlyx9sOnO9fyq35Ww83CVBNwVk
         5pfMISwHQjymR8ZqIUyIuxHQh1Qv/ssLqYO8Jbw6Sus3+gT0WWCVm3s4lEeBx+pLRb0k
         SF5akT3eFWkQ9jmOoRjwreBmcsG4ChQVUGfOXM55LlB7ghltHaGKyAe8vWty9RzZLN/r
         osHg==
X-Forwarded-Encrypted: i=1; AKwUvBwZfvO7/lJ/BNWRayTV5sOz7bqeTqk9puevcKwMpdp+A/+DUND0ZCkDo2NfEAucALgo7LC+2FDg3hpuZ2vw@vger.kernel.org
X-Gm-Message-State: AFuF++kxNLENhl33cWW4DD6BF/jxa9jFdFYXvS13JlnX/qMrf3XiakEU
	kRjiZAsSfFTWBXp95rzvMbEhfoW5aP8FiU8EMB2msl1xPsrxunRgEHBiKkZlfR+IEC9sEio10dx
	xrAcPNofh5Y2Nr+b4/e1KRn9ySUk97pU=
X-Gm-Gg: AYBFou0qLhRU0D1oJwqd61OVdnhMSHKQc9qIuXg+IkTFJMxcCN2Qjbugy7jhC8ZKC0+
	OufWC1x4YKNx9jhpmc8ml4IVYqR3TqSGqcCDt1UX0bU9SEoKmlvv16zZ8gEwfGX0t1iwfjSk/Qo
	8PbDdImQRd9I147vZi1gpjv1ZnKrhPYGlwVPmIgBEk/Z73pcSFnAn4/YZ26pv3Yglyqfwnp8HBJ
	Zfna3qlUqh2haccurpagg0/BrEvYlo+l+XuemHh3Mir2CvZmYKsOXb5CgEbDZLKHdov6f2TMPJ6
	3NHECOx9gAPsapvAtlsTOH2qWcLBH8TeMDj4U8F6lnj/fDz6M6KWuWS4Mg==
X-Received: by 2002:a17:906:6a28:b0:c29:5a76:72be with SMTP id
 a640c23a62f3a-c29667452e0mr193985066b.24.1789131405334; Fri, 11 Sep 2026
 05:56:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-1-joannelkoong@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 11 Sep 2026 14:56:34 +0200
X-Gm-Features: AcwNN1VmpaVZZkPEwLu7gA0px9cF_wj46GJyQgXpsE6qhM5m6PYwOOCkk6vrVRM
Message-ID: <CAOQ4uxhbbfn7pnq3YNMKpYDAjyZXdZcJoBpnkzjJwOdeDw9jow@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] fuse: extend passthrough to inode operations
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 2:51=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> This series extends fuse passthrough to support inode operations (getattr=
 +
> setattr) and directory readdir.
>
> The existing FUSE_PASSTHROUGH mode attaches a backing file to a fuse inod=
e
> only when a passthrough file is open. This series introduces
> FUSE_PASSTHROUGH_INO, a stricter mode requiring one-to-one inode number
> mapping, which allows attaching a backing file for the lifetime of the fu=
se
> inode.
>

Hi Joanne!

I wanted to see how we can unblock this patch set
(did someone say conference driver development?)

The main contention point for me on v2 was the fuse_entry2_out API.
And the suggestion to do a composite LOOKUP+STATX defers this patch
set to the unknown future of fusex.

My favorite solution to a problem is to avert it.

The question is how to include the backing_id with lookup/readdirplus
reply. The answer is that there is no need to include it.

I have already discussed with Miklos changing the UAPI to
widen the backing_id to 64bit and to let the server choose the id [1].

Considering the fact that FUSE_PASSTHROUGH_INO literally means
one-to-one inode number mapping, it seems a bit idiotic that the backing
id (should it be widened to 64bit) be anything other than nodeid.

The new 64bit UAPI is something like:

 struct fuse_backing_map_v1 {
        int32_t         fd;
        uint32_t        flags;
        uint64_t        padding;
 };

 #define FUSE_BACKING_FLAG_INO_ATTACH

 struct fuse_backing_map {
        int32_t         fd;
        uint32_t        flags;
        uint64_t        nodeid;
        uint64_t        ops_mask;
 };

 #define FUSE_DEV_IOC_BACKING_OPEN      _IOW(FUSE_DEV_IOC_MAGIC, 1, \
                                             struct fuse_backing_map_v1)
 #define FUSE_DEV_IOC_BACKING_CLOSE     _IOW(FUSE_DEV_IOC_MAGIC, 2, uint32_=
t)
 #define FUSE_DEV_IOC_BACKING_ADD         _IOW(FUSE_DEV_IOC_MAGIC, 3, \
                                             struct fuse_backing_map)
 #define FUSE_DEV_IOC_BACKING_DEL         _IOW(FUSE_DEV_IOC_MAGIC, 4, uint6=
4_t)

---

- Server calls BACKING_ADD before open or before lookup
- fuse_backing is stored in backing_map hash table instead of idr
- With flag FUSE_BACKING_FLAG_INO_ATTACH:
-- If fuse_inode of same the nodeid exists, fuse_inode_backing is attached
-- On instantiate of new fure inode, if fuse_backing exists with this nodei=
d,
   it is auto attached the the fuse inode
-- This attachment lives until inode is evicted (same as in this patch set)
-- requires FUSE_PASSTHROUGH_INO
- Without flag FUSE_BACKING_FLAG_INO_ATTACH, backing is attached
  to inode on open as today and detached on last close
- The server attached backing survives inode evict and it is up to the serv=
er
  to do BACKING_DEL on forget if it wants to
- BACKING_DEL only removed from the backing_file hash table -
  it does not detach fuse_backing from the inode (as today)
- BACKING_ADD to already mapped backing or already attached inode fails

FUSE_OPEN reply does not need to include an explicit backing_id.
It's enough to set FOPEN_PASSTHROUGH because the backing file
is already attached to the inode.

Similarly FUSE_LOOKUP and readdirplus do not need to change at all -
server just does ioctl BACKING_ADD before the reply.

For backward compat, FUSE_PASSTHROUGH can use the old
BACKING_OPEN/CLOSE with a naive 32bit id allocator.

[1] https://lore.kernel.org/fuse-devel/CAJfpegve9GMTRwvoA5y7AzUSD4e_EDJFzsq=
hCVN8xQ+RjQ=3D+Sw@mail.gmail.com/

What do you think of this plan?

If you are on board, do you want to take the lead or shall I try to allocat=
e
the time for it?

Thanks,
Amir.
