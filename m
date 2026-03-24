Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45674352921
	for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 07:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774338825; cv=pass; b=g83H5zbeVWN9zHNc1cNimi+1bo877NULzyhjzwbsCX30/ymJHNvYrkpgrPsun64xOSxyJnoWbySBxdkCmi8NjmMdzYYaoaC91hThI7QNXKGwpwQYoYaPs9bsF1LrgfPS0ZHO/l4FYo+zTCYwv/TGC8pP+7GKQmT9nV2CbTN8NAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774338825; c=relaxed/simple;
	bh=EkHahqFiKzq0hXwxECnVuQUIAlqeYMLsbgChKFxta08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kenBBaZQxtbPbtQgYojj9IFtx9xYGE5KWB1klQmVSgnSQq+qDCEfNZVIXpKD9te+nl443XTbURSer/uR8ox12XgKZ2rjwcnN1ufgyd7vf21PwwsAAB17lztrc9EmTeMegB5iY565lNAiMrDH9tPNRMz87UTsiJVoLE1zeA9TAqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UXWj93Ix; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXWj93Ix"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b8f97c626aaso801134366b.2
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 00:53:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774338811; cv=none;
        d=google.com; s=arc-20240605;
        b=LJfdZqsOBsqveyYqRPlHNwRO4dypqa+lmJB+3ZMj34hF/R/vEiipV2y3/Tvlj/qYQd
         JIKoopnIgxPlwQxbA6ziGfQHtxORxYmvyDnNBV6IsYG5sq5Wpbw7n86E1554sy04qBnZ
         hlcUZGHk0m29t7lRNz0MWTHkvWAsb3+lyOM48oRQqCz7cLZWdumyVbgbmHfrPWjbwtz5
         vJ8ZIl35gFNFXkkQ9db3hsTUqUUbWdXcA75uQL0U5sakc5C76GidZOnlfHRyROq1LVNu
         7u/zsxSwmXFQvl09xUap0G98SMvYHnIjcg8zhyYEDboVK8c5oINoL0z39ZwPPUTe5unG
         Xdlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BvlIol/fyMPbQwPX/OXsXdgiKOBBe/R83FLdoCNg1RY=;
        fh=MSGsUR5FGye71XVJlRDFtPSqwCoGaZ2BTMiUzqIeGRQ=;
        b=ku+cNq8jV0gF3NV/0QottokKVKiNXokLYtZtTSMY7aHUvajuZRLrQkYIOTFMjIZqE0
         YT+9NKGuPcBawB0AJTkYe0s41BTczH+JLNfxe+Z1y9PpEv8mOnt2r8GEsJLkQza0vmxp
         qZVXXywQfTGdhZ+BU/QD/0BRqa9QpbUO1XhIA26HFNA5Yi6QxRlhYNVeeeOojNe6liCp
         xZ6ZziVhq3J/ilZ2/rDk+bvRDzORz4umYglZouGJ/FTGvfONJB32daVRUADmx8qc0Bf8
         79S4xsdIqaul7WneU+VYHGGmIFuxsuOAt3nneDsUGUVtzc5r95mfDM4JSG2lrF6RC1D4
         b/Fw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774338811; x=1774943611; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BvlIol/fyMPbQwPX/OXsXdgiKOBBe/R83FLdoCNg1RY=;
        b=UXWj93IxztkZMV/i0SthmZJjuhzAm0hyPkRv5spOGA8Y0hl0mczMZ8R0cTvwa2lUFQ
         CYmjnGeVwEsUGCj0KPqZ4afL9p0pXHhnZCfH7pLEUPRPel7GhC/VgqLUYljELw270h5f
         3AeeBKx69DxrLqtXg6epER4oXyqPvzo7GnBkIyJSioJFjBIVXLzjzrP9KdRrhT3XuSdp
         pg4rLnGZ4uU42LgGFA7CtKcD3hTlwueLBNGNe7Tt4E1v3LnkzCp8EUx7Kl7pge6XKMFq
         8tVGILHXiEbIh8KPfscQZKACd+uP+lNWYfgyOkm+52UnQdpL0XkpJpb7AiNjpvfVqi97
         50IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774338811; x=1774943611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BvlIol/fyMPbQwPX/OXsXdgiKOBBe/R83FLdoCNg1RY=;
        b=SQoWgmvMiPmWpSYE4aE0lQ/XQZEB+0J8bm+ButADuXWTJvMhuwCtTq66Gynz4/gQui
         Dww73cYbviievSJ/PDHgw/bgj7pyXfCENWBKPM8zTucVvQ4fv76cspbHinR0mXcYXsSy
         c3OqjpOLHZasf6S3Bf6OTHBiGrqHQ+WCUe9CYIVMnWpcQHyt2NuE5eaZm4LdlIgWqccl
         hEQ4l/3WD/0LfVwneSTmfVWKz+8X+Ir1x/KkWJYvJURxu+Z3mxWF6Mjc2Zzs2CH9lANP
         PNEf82f3p1+xcK44Fxzpn6UnvzQNR61lZXKATms/DYJGxRxuiP+07WH+MTaOHP8YpfqX
         4Mww==
X-Gm-Message-State: AOJu0Yz8pP7KTiz5rMuPpbSRuUqed1vMZz9v1tad8sMfn83HV852LePX
	nQ7gS+2E4HKZK15AyBsXF0JQGOZ0qQyI2TcAQOHAQt4H3CSrwybaJxQc6z6t73ttuweIFtfjl/Z
	hVmb6DX/y+BIumow9h9B0ZVy/Cl9efLs=
X-Gm-Gg: ATEYQzxZls3ZGtaEozSl4onlPBubrcdMeLBZfqyKkV3ovULe+8mmkJQoHI0RPnl7O/N
	YdZtbTzeOm5WIws0F8G2nOeA7TMkbmwbcsmA4q7FMDs2QtrBu8e7N+UXo8Flo3OkxPvksVs4QUo
	z000NydTntTWpIcqBueczowDI9vi/30+i48v/r/MRw53HX6XA0c/fnAMgDlFttgF8zHfxGoWea+
	bYyohpNMAtk7FM1WzdtsYyogvL+FzB1HY277+SR3jt/XXp78Ubpw3FxqdOiwMoCALu/WRH9KEeV
	dw2jt9B8prWysxuFXHWjwhnQIxClgxRc7dc5RbEcNg==
X-Received: by 2002:a17:906:5994:b0:b94:1771:5296 with SMTP id
 a640c23a62f3a-b982f27d258mr722760466b.23.1774338810639; Tue, 24 Mar 2026
 00:53:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOdxtTadAFH01Vui1FvWfcmQ8jH1O45owTzUcpYbNvBxnLeM7Q@mail.gmail.com>
In-Reply-To: <CAOdxtTadAFH01Vui1FvWfcmQ8jH1O45owTzUcpYbNvBxnLeM7Q@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 24 Mar 2026 08:53:19 +0100
X-Gm-Features: AQROBzDDpxDWrnI_0ErHKf9B-NvnkFzklWGTuiS7-g7t4QluNxFJT4EpViODXMc
Message-ID: <CAOQ4uxjuAfCJXGRchDf-7d+uCS+8=Du_Y8OzgX15w4-fOR_oHQ@mail.gmail.com>
Subject: Re: [REGRESSION] fs/overlayfs/ext4: Severe jbd2 lock contention and
 journal starvation on concurrent copy-up (v6.6 -> v6.12)
To: Chenglong Tang <chenglongtang@google.com>
Cc: linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, jack@suse.com, Jan Kara <jack@suse.cz>, 
	miklos@szeredi.hu, tytso@mit.edu, adilger.kernel@dilger.ca, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, Kevin Berry <kpberry@google.com>, 
	Robert Kolchmeyer <rkolchmeyer@google.com>, Deepa Dinamani <deepadinamani@google.com>, 
	He Gao <hegao@google.com>, Fei Lv <feilv@asrmicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 23, 2026 at 11:03=E2=80=AFPM Chenglong Tang
<chenglongtang@google.com> wrote:
>
> Hi all,

Hi Chenglong,

>
> We are tracking a severe performance regression in Google's
> Container-Optimized OS (COS) that appeared when moving from the 6.6
> LTS kernel to the 6.12 LTS kernel.
>
> Under concurrent CI workloads (specifically, many containers doing
> Python package compilation / .pyc generation simultaneously), the 6.12
> kernel suffers from massive jbd2 journal contention. Processes hang
> for 20-30 seconds waiting for VFS locks and journal space. On 6.6, the
> exact same workload completes in ~4 seconds.
>
> # Environment:
> * Host FS: ext4 (backed by standard cloud block storage)
> * Container FS: OverlayFS (Docker)
> * Machine: n2d-highmem-96 (96 vCPU, high memory)
> * Good Kernel: 6.6.87
> * Bad Kernels: 6.12.55, 6.12.68
>
> # The Bottleneck
> During the 20+ second hang, `cat /proc/<pid>/stack` reveals three
> distinct groups of blocked processes thrashing on the jbd2 journal.
> The OverlayFS copy-up mechanism seems to be generating so many
> synchronous ext4 transactions that it exhausts the jbd2 transaction
> buffers.
>
> 1. Journal Space Exhaustion (Waiting to start transaction):
> [<0>] __jbd2_log_wait_for_space+0xa3/0x240
> [<0>] start_this_handle+0x42d/0x8a0
> [<0>] jbd2__journal_start+0x103/0x1e0
> [<0>] __ext4_journal_start_sb+0x129/0x1c0
> [<0>] __ext4_new_inode+0x7cd/0x1290
> [<0>] ext4_create+0xbc/0x1b0
> [<0>] vfs_create+0x192/0x250
> [<0>] ovl_create_real+0xd5/0x170
> [<0>] ovl_create_or_link+0x1d7/0x7f0
>
> 2. VFS Rename / Copy-up Contention (Blocked by the slow sync):
> [<0>] lock_rename+0x29/0x50
> [<0>] ovl_copy_up_flags+0x84c/0x12e0
> [<0>] ovl_create_object+0x4a/0x120
> [<0>] vfs_mkdir+0x1aa/0x260
> [<0>] do_mkdirat+0xb9/0x240
>
> 3. Synchronous Flush Blocking:
> [<0>] jbd2_log_wait_commit+0x107/0x150
> [<0>] jbd2_journal_force_commit+0x9c/0xc0
> [<0>] ext4_sync_file+0x278/0x310
> [<0>] ovl_sync_file+0x2f/0x50
> [<0>] ovl_copy_up_metadata+0x455/0x4b0
>
> # Minimal Reproducer
> The issue is easily reproducible by triggering 20 concurrent cold
> Python imports in Docker, which forces OverlayFS to copy-up the
> `__pycache__` directories and write the `.pyc` files.
>
> ```bash
> # 1. Build a clean image with no pre-compiled bytecode
> cat << 'EOF' > Dockerfile
> FROM python:3.10-slim
> RUN pip install --quiet google-cloud-compute
> RUN find /usr/local -type d -name "__pycache__" -exec rm -rf {} +
> EOF
> docker build -t clean-import-test .
>
> # 2. Fire 20 concurrent imports
> for i in {1..20}; do
>   docker run --rm clean-import-test bash -c 'time python -c "import
> google.cloud.compute_v1"' > clean_test_cold_$i.log 2>&1 &
> done
> wait
> grep "real" clean_test_cold_*.log
> ```

I don't understand.

You write that Python imports in Docker forces OverlayFS to copy-up the
`__pycache__` directories, but the prep stage removes all the
`__pycache__` directories.

My guess would be that rm -rf __pycache__ would generate a lot of
metadata copy ups, but you write that the issue occurs during the
2nd stage. Maybe I misunderstood.

Please try to figure out which and how many copy up objects this translates=
 to
for directories, for files?

>
> On 6.6.87, all 20 containers finish in ~4.3s.
> On 6.12.x, they hang and finish between 17s and 27s. Bypassing disk
> writes completely mitigates the regression on 6.12 (using
> PYTHONDONTWRITEBYTECODE=3D1), confirming it is an ext4/overlayfs I/O
> contention issue rather than a CPU scheduling one.
>
> Because the regression spans from 6.6 to 6.12, bisection is quite
> heavy. Before we initiate a full kernel bisect, does this symptom ring
> a bell for any ext4 fast_commit, jbd2 locking, or OverlayFS
> metacopy/sync changes introduced during this window?
>
> Any pointers or patches you'd like us to test would be greatly appreciate=
d.
>

Very high suspect:

7d6899fb69d25 ovl: fsync after metadata copy-up

As you can see from this discussion [1] this performance regression
was somewhat anticipated:

"Now we just need to hope that users won't come shouting about
performance regressions."

[1] https://lore.kernel.org/linux-unionfs/CAOQ4uxgKC1SgjMWre=3DfUb00v8rxtd6=
sQi-S+dxR8oDzAuiGu8g@mail.gmail.com/

With metacopy disabled this change introduced fsyncs on metadata-only
changes made my overlayfs which could generate a lot of journal stress
and explain the regression.

But we had not anticipated that workloads could be affected with
metacopy disabled, because it was anticipated that data fsync
would be the more significant bottleneck.

Do your containers have metacopy enabled?
If not, why not? Is it because metacopy is conflicting with some
other overlayfs feature that you need like userxattr?

Thinking out loud, I wonder if metadata copy up code would benefit from
calling export_ops->commit_metadata() when supported by upper fs
instead of open+vfs_fsync(), but I doubt if that would relieve journal stre=
ss
in this case.

Anyway, please see if forcing metadata_fsync off solves the regression
and I will stage the original patch from Fei to make metadata_fsync
opt-in.

Thanks,
Amir.

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -1154,7 +1154,7 @@ static int ovl_copy_up_one(struct dentry
*parent, struct dentry *dentry,
         * that will hurt performance of workloads such as chown -R, so we
         * only fsync on data copyup as legacy behavior.
         */
-       ctx.metadata_fsync =3D !OVL_FS(dentry->d_sb)->config.metacopy &&
+       ctx.metadata_fsync =3D 0 && !OVL_FS(dentry->d_sb)->config.metacopy =
&&
                             (S_ISREG(ctx.stat.mode) || S_ISDIR(ctx.stat.mo=
de));
        ctx.metacopy =3D ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags=
);
