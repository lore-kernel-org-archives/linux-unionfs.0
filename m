Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC3944F54D
	for <linux-unionfs@vger.kernel.org>; Mon, 19 Oct 2026 09:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792400613; cv=pass; b=QKGZp8XhpP93pRfwWZ1e9NpWd5SgHajjGJlHr56hWyqezWEpjY/tt09EEBrp06UoAiPuLd7qEpFIwrVUJF5UXbLbDNoZB9X8xt6rGjQ9h2xiCk2f/Hho+DFpG6tk99vnchClRmizar2RK0xx3QUnBUFNKLsmhtldPAtiBC0jVGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792400613; c=relaxed/simple;
	bh=fuxqQ+tD7DylDffylfpxIVNQwIoMDvXpxPmzZop1mxM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=D4MHuiSAB7xlxQAV4QUzsHWStaisczwsXNTX9AqMmJzD7dLBlsK6CQE9yh6W46F25Fv5jezwSHji2ZDLMR/M0rHKHoGfK/8gk4L1LXGt+oG8JkSS0G3XmxFDgu3RnckeZpzqvVn2FXlL779h/faM9SuYMtRCG+bp2SoLlPefmhA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MnHymimK; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MnHymimK"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c434376dbebso171654266b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Oct 2026 02:03:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792400610; cv=none;
        d=google.com; s=arc-20260327;
        b=Y4xiJ9towOqQWGw7Y48X4KerQ6J3mEfJGmeafmQb0MG1ThyX1ohXWMpnhPQrE79TIq
         7anHegv+DWbVtvwRWTiH+ntYbR+H44fNPmSnocOewZ+KqjHCbSj9AE+X7TzraxUPFbtm
         5vpjgQRdB1IQe1fhKv/PZBaAw3qS5ObSud1ARpuCaXeGtJNpGFYi8MlddvnTDfu3eLUe
         AszgTr2hJgNL3NFnNYc/AYxzEmhZvkWSqOgBPrjvYdn9wPaBJbdFHyACZKASFVFIy+DJ
         qYerCLiHwBUWl2RNKwBxAE49e/+i5r7wWrp94JJZ1g2wnDZ6l5Ozrqug+ZxNtsHOK9Wo
         nSLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=btI5b4NYBKhWiTT7g2SaCW5SPW+H1/AeKO+HgacT8Bw=;
        fh=lUMnrQNWIDTEGwvnCPZdNT6eG06rRU9I8vTaYbdbcL0=;
        b=N67s7UlUqM54n3CUkCZ4bYAwlDWC/n21BxvqbNYxcKRt82nBmqZVecVqsxPYeZPu6S
         8KErBHcnc38Qf3epKZKD289py5i1Zn2DmSHRwa7VKot4a0Jniaqr5J5Aqnr1M6ZcGcmV
         cCt5hZ/7BXVlIg1LRjWsAnHHvzyhOUeaHBVC5ukQBLWTHzpnVtO6yoCaSw1GNk5ESxVR
         sun9cXsM+ovkwKm+neJ6G72Jynsyuns/Naacp6QE4aRcrnhe8OT6P88Z4IVnx1DH/e9T
         YCzeaXnHVlQR3qQUUB50Zt/pO9GqCjvE7kjx6zotMI/zidEtoZ6gGXFKOwqGxfXDdRK2
         yo1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792400610; x=1793005410; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=btI5b4NYBKhWiTT7g2SaCW5SPW+H1/AeKO+HgacT8Bw=;
        b=MnHymimKCDg2vDblm3yT0A+pvzWDJ1gI33YFVI/PSfsUXMQaypxERtofuXMMpdpQPr
         FbV92P9Bo8gdDJR2dGEVuheUoar0ZwhvSupQ7wtGXymAdVK6kDnFOQXaObXSJTsih/VB
         Uo7qcu9QSaWPB/evCBH2TSBQ2BSkH30zc1Sm+LBppiI1GYMFm3GhTUE5wiUTsUKlNgnv
         cv/Dh2mzu2OZ8h65DY6wpIoDScWEjQ3koubONdX9GlA/hGVOPP79E7v3izibVZ6bU7k9
         L7UakgGM+/Q6pQYsdWvI9/9DhJQSbEDk9P3RkbXYqzaxZZReLX6OpcdXyLQC388GbglJ
         xbhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792400610; x=1793005410;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=btI5b4NYBKhWiTT7g2SaCW5SPW+H1/AeKO+HgacT8Bw=;
        b=nepjDM4lovAeB8D2/yo9iY1Sfdp4YuIM8C/08S+HVka+8966Av5wUubmGjJ2dotWaB
         0uNXmXm+Rc6e/cYn5FhUyNXrRGFHcEggqIzATSwhcWCpDXFC4PSAeFE9rBltNzkya+K7
         KKHRDgoOPjBBlrrSZOjzofnyOgA7Rmvs4RBrUF3oRcp1sYSGlsG7XfMXFJ3DIaTG0F9A
         c9JYAiCEOgSv0w4/UHl1RovUiUsnxyOj76IweNsPqKfmigmyEBuSbdkVlzHYVvdGrpl9
         pJiwly9+PgmG90uqkAdM0GNvF0mTHT5mXZgjntqAQ/1AiQ96wPsdex6+r2f//tnFbMgo
         V6dg==
X-Gm-Message-State: AFq9FYJj0aHylGiVmDPuL79VyJYzqyJqIPuCHb5wFe8tjfDYbZeADBb5
	XIqcHnYk2w7M72jfFEz8UeYiqvzyxKC0VyA2QoeFCUBUmwCHG1kpEdpp8ANpK2Anln07M/TFcFj
	m7GtgG2tJXlR6x4jMqMZYx2vonsPF1KplLZTR
X-Gm-Gg: AYBFou0Zrh8qafhI8iKe0bCfcJSPwrH6BeC+AS+bz5k/TJ8PAuXQ4NnVWPQZLgh/dI1
	yBMp7niKA3AqeeOPqHRDlPMqfs/eb/INskHXCdYU3hXjuiCxiC8Ft+rQaR14IhTyTy0P//bDUUw
	LE2CeurGjb9QcdUhZwBn4CVPiQtidXOaMHCR4F+NaG76AyU/XYkP9qGJodAe9THZTPtC4cHIH6m
	X72nY5WNreMsszg01vrziIczeRA989OqnFPhqQPOXlGMhXYhWCVeaosvAilLCQ49t/RXzoXIx+d
	l7FiwiWSfvms2pNYZb+yMhcwU6bfwjTm8VDOnYOFNryGmr3WRgAvAnHb+SghWTJ+U0UCFI6pisj
	Qy9i53WhFqwJR
X-Received: by 2002:a17:907:2d94:b0:c42:4557:452c with SMTP id
 a640c23a62f3a-c4245574af6mr347230866b.8.1792400609324; Mon, 19 Oct 2026
 02:03:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Claudio Fernando Pinto <claudiofernandopinto@gmail.com>
Date: Mon, 19 Oct 2026 06:03:17 -0300
X-Gm-Features: AclHuK_L8gqHgvPTdsvh6QXtOxLsYcgjeNl5xe03pNlJ309cbPzfcQHTAVmU44M
Message-ID: <CACs2WyyyGBxznvnJRDYWziAbzz8QROr41CF9Wtu9fOj7jX1fDw@mail.gmail.com>
Subject: overlayfs: unprivileged writes can use ext4's reserved blocks with
 the default resuid
To: linux-unionfs@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org, 
	"Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"

Hello,

ovl_fill_super() lowers CAP_SYS_RESOURCE in the creator credentials with
the comment "Never override disk quota limits or use reserved space"
(fs/overlayfs/super.c:1511 in v7.3-rc7). On an ext4 upper with the
default reserve owner, the second half does not hold:
ext4_has_free_clusters() grants the reserve when the allocating task's
fsuid equals s_resuid, 0 by default, before it looks at the capability
(fs/ext4/balloc.c:654-657). Writes through overlayfs run with the
mounter's credentials (ovl_write_iter() sets .cred = ovl_creds(sb) and
backing_file_write_iter() applies it), so with a root mounter the fsuid
that reaches ext4 is 0, and an unprivileged writer can spend the blocks
reserved for root.

Reproducer, a 64 MiB ext4 image with the default 5% reserve (1146
blocks), the same user ("nobody") filling it once directly and once
through an overlay mounted by root:

  direct:  reserve=1146 free_after=1146  (reserve kept)
  overlay: reserve=1146 free_after=327   (819 reserved blocks used)

v7.3-rc7 (24a19b953e2a), arm64 under QEMU, writer uid 65534; the same
on 7.0.14 in Docker Desktop's VM (1148 and 331). Script below.

I ran into this in an out-of-tree stacked filesystem I work on, which
copied the overlayfs approach and had the same gap. There I now run
data writes, fallocate, clone and copy_file_range with a copy of the
mounter credentials that carries the writer's fsuid, fsgid and groups
(built the way ovl_create_or_link() builds creation credentials, and
cached per file while the same identity writes), so ext4 decides the
reserve as it would for a direct write. I do not know whether that is
the direction you would want here, given the per-write cost and copy-up
also allocating with the mounter credentials, or whether this case is
already known and accepted as one of the behaviours that cannot be
implemented with full fidelity. Is it worth a patch, or should the
comment just say that resuid/resgid still apply?

Thanks,
Claudio

---8<--- repro.sh (run as root) ---8<---
#!/bin/sh
set -u
cd /tmp
for case in direct overlay; do
    rm -f img; truncate -s 64M img
    mkfs.ext4 -q -F -b 4096 img
    mkdir -p /mnt/low; mount -o loop img /mnt/low
    cd /mnt/low; mkdir -p upper work lower /mnt/ovl; cd /tmp
    chmod 1777 /mnt/low/upper /mnt/low/lower
    target=/mnt/low/upper
    if [ $case = overlay ]; then
        o=lowerdir=/mnt/low/lower,upperdir=/mnt/low/upper
        o=$o,workdir=/mnt/low/work
        mount -t overlay overlay -o $o /mnt/ovl
        target=/mnt/ovl
    fi
    set -- $(stat -f -c '%f %a' /mnt/low); reserve=$(($1 - $2))
    dd="dd if=/dev/zero of=$target/fill bs=64k 2>/dev/null"
    su -s /bin/sh nobody -c "$dd"
    sync
    set -- $(stat -f -c '%f %a' /mnt/low)
    echo "$case: reserve=$reserve free_after=$1"
    [ $case = overlay ] && umount /mnt/ovl
    umount /mnt/low
done
