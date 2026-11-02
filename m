Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793622877;
	b=jY6s+iClUJXvX3yNdLykPYCF7ZwsV2m5WT6aHqCQkVcRTiT3ucsDp88IfpghXBnrTEAX
	 f8oxB1pDUIO02SclOnLdNNG6zFxEdUyi/fBkg0kp0BAmDUIGhvfptjDWNTDV203nqyK2b
	 SPBvX9oh/61Guzb/QJ9w7I2zy88qwjtLWQzrcRNAscczD6SZS1cKTWHB3av5SlntSyto3
	 abc7e2bER6kA3T8aa4MMnr9trC5d1LQtgOyyeHMFdWaFWeIv4qvY8YqwuCHlEf2IA4VeJ
	 4ARv5tnFOQLLCigM+wQxM18uVO0T5I2+3fU0D9m39LqubqTi6Tm8n6LRxe6G4Tu2tZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622877;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=jXPXHbGLmRwUEbj13/FmJNOUje1/462ix0xFNYMTlBs=;
	b=vA99Q6wsUBTpPBM7DI0QDWcpQpnBvn6/xabOKD862+VIJB6GUsmv8pIq8VPfESoLNE/G
	 EkJBsX7gV7KV8Vu3sNeu5P107iC6XEvMHDJcVxyie4X+eghTehgR10OwYQVNZhvcDNJmZ
	 fS5hhna4RC9qaC4Qof6hA0Pqbz/d6DUsrRkO7WhJUMUpMiME6RDk9pYgtZVrY5/MtxtKo
	 UNJSsKIEapdK8HhwiGEoVsDoYO3faWX/c3aqVJQsi717e9usKmfRSQALcsA1fj3Sl5msF
	 TDtwwGQEyC/ywZpzBFJiO80OsHC2b/5LR759H8f2NIkBchpGRK5WkoHikRaMQa4F/iQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yUx6bat9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C4660A261F
	for <linux-unionfs@vger.kernel.org>; Mon,  2 Nov 2026 12:34:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63C4660A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yUx6bat9
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6af9a9451daso4710984a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Nov 2026 04:34:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793622876; cv=none;
        d=google.com; s=arc-20260327;
        b=TvXJKgfgmoESIDTAoVWOfQw95h/76Ts7qQ+zZOlime2+PbKPjQcSlA7eVOV8OyH4HM
         BQ4LQH1d/RB24HAywxSCTmEq3YkbVjrAe+eLWz2JcARgki43Mo+tmxJe1mQqr5usahmb
         d75T6Tij0sAZXntp69LzdOzs9+15+R+Ct8FQfUPlU+JWq8tYBd+yuapmcWPd121LKH/7
         NTZ91GbycJLWS5KEf9/uKRapPBCsts5RoQDauOzBrV4qvvFDCtCaPu4ljsMNNVGWP1XV
         5VRzeJYfWM+ETOyc69Mj8AuUy/BLjv5HzbarYX4RfPOfgGZEeJJ+7N6trvYJpVZh1X9B
         sxSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jXPXHbGLmRwUEbj13/FmJNOUje1/462ix0xFNYMTlBs=;
        fh=22IAZG8m3BDliJCHfXuQdoIGdMA1394/arsx9GpR2Mo=;
        b=pzEnqfQGRHHesiUqhl7E+kXxOUfqIwB9MXc7ReMQSF2FQae1Kv/QZ70ClGmtsbojeN
         LjPx+RTn6HrbWmc5MLf24keO20bMiuwFbUPvr31ccJnGx7myxUIYgYBgMc5IhFa/g4CL
         Mssg26oeCr5Rtdpc8z5jNtlnN+r0SkZsBQ/1yth1nlDqDe4KXiVXvo6t1LWttruioh3N
         hjeKMc+gDcavaumtbtE/w9rmigGzjyf93yvc9FthXiPydUkJuiDocplJqii8M61DoRvV
         ThFn1Dd0ZYamhuYHVRmiWxIna7yiITDny/maCmkyEyDv/7hY2VrvfUSxUvCHC7+w+MKn
         0UGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793622876; x=1794227676; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jXPXHbGLmRwUEbj13/FmJNOUje1/462ix0xFNYMTlBs=;
        b=yUx6bat9dLzzpue/1IlnCNZvP/K+mJdPxIp9fJoUR/XMZOSFjO5t8FvKk5iOw+nZ6U
         9fq0h8gxpkrJTYOiBWb96pWkprRjOv2jO+kRlM1tK2ghN8wEe9kjrAg8rqOjuxM1i4E8
         TCYTuFFKjRJLSlnSw3SHTOudB1l4QQ1ZxsIYB3kG2CiIo4N6/4/xE3sz9q0MLDcX1dkY
         omQnfwQNDNNs49PYCyTXYuGQmeUT/T6fXkAn2kipVvkx3+1+Ky7UvhxExhsq6DA9jAs5
         Q6Zp74GXur6POb6+8ZGTDx/Qxw6EMgkqGvuTsjKjaMC/cyUcroPeL03OOL3lDXFgIOiQ
         2cFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793622876; x=1794227676;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jXPXHbGLmRwUEbj13/FmJNOUje1/462ix0xFNYMTlBs=;
        b=elGo1nbCbvBFZj/pLf8uOhNTXQm7cdzQCSc2psw0k4uE8jX6UXIi4GmP17rKci8YfG
         OulTSTSZ/1FgzDXF1hpkWvYo/whSsknJhOSZNOJgF9xRHnQ8UkUedoNWOKF3husJY9ok
         jeS94EyUCVgiZKYAU+ARqwCiaM1v5VoU+8ll7lbWrfqXQU8Fso14Diz21OwA9wTf6qze
         2aLy1BiA9BsTt/uwwHNR1glpD4dEoSiJxghVfnGAnIBdIDmb0LANrhc7ZPxp+1pZad/8
         qSBB9bkT9ZWb4zzedJLvKQ27Y4yGXvQ10kIHrN345acgzqUPmYv5NtvELbWpDMaUIMZ2
         KdwQ==
X-Forwarded-Encrypted: i=1; AKwUvBynqREhp3CsqKgTtY7DwWiZUhhZ6oqME+ygK6x9oZpb3fNMu880uhvzQaI3l1rAL4ydIZZH7hUs/zIFX4AK@vger.kernel.org
X-Gm-Message-State: APuU4Z9pf01HuMtx9nsU40N7+c7rvbGYaxqAG3jRk+m0iD7rHIQfPnL6
	hC3aY9cJYy+NnEjqXB6bMM53e2G/2exG5qhaayl1a+TTeMPLAVwM08QvzG2QDRtniiZuM3JzwMI
	4c+Fjvs1SknYymIhqryUtLYDUOwASppA=
X-Gm-Gg: AYBFou0JCydFA7ZBCfk4pQPLSPXAEUpVWw7gscyJoPw+qtsWcFkC8miEYkLXpUZdoKd
	sckZTOk7cKWB+EQMl9IFi8Xjm7XW2SffXtwPiAK4vxRIeOlcuORltLYF0Bk/ezQ1UR//vjTrLQB
	ziuFDEf0K59kSqnYiHaFLBraeIytpK28dXAFo/mCrjE4DmHxIDH+GrFrEuWPbdN1Jxln9pnMiIq
	FnZJGrc5ZcR3kHTFw3gUPB3JOf8qecCMBKo4rRuFJIwRJkjy1UzLaMXOAO1VrSlmbQr0iZKkPTQ
	UFNSIeSbW651iba7B77AMbQGdMG56Zwhi6EgaycEo0I4be1YkO/P44RKR5qvSD2XpUuxAVosJKC
	jBiNZ8Txxp2mWnRc2uy5HnVptRmCiSQSIIDV1ohuiWLjm80LnmNcn9Vc2M/11oZ2s5srT9Q==
X-Received: by 2002:a05:6402:27d4:b0:6b4:7f3:a9cb with SMTP id
 4fb4d7f45d1cf-6b4d64b21c9mr7700361a12.42.1793622875571; Mon, 02 Nov 2026
 04:34:35 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <P58Wrer--F-9@tuta.io> <20261030-welpen-anbinden-nullen-b2432cee1d10@brauner>
 <CAOQ4uxjm=cGPnug18VuhKqiMvkWwLPNLO_TE3KxO8iLZG+veYQ@mail.gmail.com> <P5Qu3co--N-9@tuta.io>
In-Reply-To: <P5Qu3co--N-9@tuta.io>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 2 Nov 2026 13:34:22 +0100
X-Gm-Features: AclHuK-3l0X1DZnRELP5P6NZd7vQR4-Zao9dTN5laF0U0H6VcezU-bslUhQpM0w
Message-ID: <CAOQ4uxh67+vs0mr-Lxmwz9-N+F8m29WUNz+8qFLLDpOVYB7=vg@mail.gmail.com>
Subject: Re: [PATCH v3] fs: let backing files inherit FMODE_NONOTIFY from the
 user file
To: Edvard Conrad <edvard@tuta.io>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000005c4f71065f4a5edd"

--0000000000005c4f71065f4a5edd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 11:58=E2=80=AFAM Edvard Conrad <edvard@tuta.io> wrot=
e:
>
> On Fri, Oct 30, 2026 at 6:13 PM Amir Goldstein <amir73il@gmail.com> wrote=
:
> > Would you mind adding test cases (or variants) to fanotify26 to cover
> > this find and test the attached (sanity tested only) patch.
>
> Two things on the directory side, one settled and one not.
>
> Agreed on 130fdbc3d1f99 ("ovl: pass correct flags for opening real
> directory"). Before it ovl_dir_open() passed the user file's f_flags to
> ovl_path_open(), and __FMODE_NONOTIFY travelled with them; the commit
> reasons through every O_* flag but that one is not an O_* flag. That
> fits v6.13 failing the directory case and passing the file case.
>
> The one that is not settled: with your patch, listing a merged
> directory through the event fd still deadlocks. ovl_iterate() sends a
> directory that has OVL_WHITEOUTS to ovl_iterate_merged(), and
> ovl_dir_read() opens each layer with plain ovl_path_open(), which no
> user file reaches. A listener that calls getdents64() on the fd before
> answering blocks here:
>
>   fanotify_handle_event
>   fsnotify
>   fsnotify_open_perm_and_set_mode
>   do_dentry_open
>   vfs_open
>   dentry_open
>   ovl_dir_read_merged
>   ovl_iterate
>   iterate_dir
>   __x64_sys_getdents64
>
> Two controls on the same kernel: the same merged directory without the
> listing passes, and a lower-only directory with the listing passes,
> since od->realfile is nonotify with your patch and iterate_dir() uses
> it directly. That was on 6b4b543fa18 with your patch applied (with some
> fuzz); the readdir.c paths involved are the same in today's master. I
> have it as an extra case in a local copy of fanotify26 and can post it
> once there is a fix to run it against.

Good catch!
Please test the attached v2 patch and post the new test cases.

>
> Incidentally, I was thinking about your ask for something more
> generic: a task-level "creating an event fd" state in fanotify would
> cover the file and directory opens in one place, and the copy-up opens
> in copy_up.c too, which also go through plain ovl_path_open() and
> which an O_RDWR group would trigger for a lower-only file (from
> reading, not tested). It would not reach the listing case above, which
> runs at getdents() time, long after the fd exists.

Writing into fanotify provided fds already has issues with potential deadlo=
cks,
so I am not excited about making more changes to overlayfs to avert this.

Also it is the fd which is supposed to be marked NONOTIFY and not the liste=
ner
process because the listener process. We have thought about other models as=
 well
but for now we need to keep it this way.

Thanks,
Amir.

--0000000000005c4f71065f4a5edd
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="v2-0001-ovl-inherit-FMODE_NONOTIFY-when-opening-directory.patch"
Content-Disposition: attachment; 
	filename="v2-0001-ovl-inherit-FMODE_NONOTIFY-when-opening-directory.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mvz8lw070>
X-Attachment-Id: f_mvz8lw070

RnJvbSBhZmM4ZTYzYjMwNTRkNjVmN2IwZjJjMWFkZjg5M2FkNjI1NTE0Mzk3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBGcmksIDMwIE9jdCAyMDI2IDE4OjA3OjAyICswMTAwClN1YmplY3Q6IFtQQVRDSCB2Ml0g
b3ZsOiBpbmhlcml0IEZNT0RFX05PTk9USUZZIHdoZW4gb3BlbmluZyBkaXJlY3RvcnkKIHJlYWxm
aWxlcwoKV2hlbiBmYW5vdGlmeSBoYW5kcyBhIGxpc3RlbmVyIGFuIGZkIGZvciBhIHBlcm1pc3Np
b24gZXZlbnQgb24gYW4Kb3ZlcmxheSBkaXJlY3RvcnksIG92bF9kaXJfb3Blbl9yZWFsZmlsZSgp
IG9wZW5zIHRoZSByZWFsIGRpcmVjdG9yeSB2aWEKZGVudHJ5X29wZW4oKSwgbm90IGJhY2tpbmdf
ZmlsZV9vcGVuKCksIHNvIHRoZSBsb3dlciBvcGVuIGNvdWxkIHN0aWxsCnJhaXNlIEZTX09QRU5f
UEVSTSBhbmQgZGVhZGxvY2sgYSBsaXN0ZW5lciB0aGF0IGFsc28gbWFya3MgdGhlIGJhY2tpbmcK
ZmlsZXN5c3RlbS4KCkV4cG9ydCBkZW50cnlfb3Blbl9ub25vdGlmeSgpIGFuZCBjYWxsIGl0IGZy
b20gb3ZsX3BhdGhfb3Blbl9yZWFsZmlsZSgpCndoZW4gdGhlIG92ZXJsYXkgdXNlciBmaWxlIG11
c3Qgbm90IGdlbmVyYXRlIGV2ZW50cy4gIE9yZGluYXJ5Cm92bF9wYXRoX29wZW4oKSBjYWxsZXJz
IGFyZSB1bmNoYW5nZWQuCgpSZXBvcnRlZC1ieTogQ2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxl
KSA8YnJhdW5lckBrZXJuZWwub3JnPgpDbG9zZXM6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2Fs
bC8yMDI2MTAzMC13ZWxwZW4tYW5iaW5kZW4tbnVsbGVuLWIyNDMyY2VlMWQxMEBicmF1bmVyLwpG
aXhlczogMTMwZmRiYzNkMWY5OSAoIm92bDogcGFzcyBjb3JyZWN0IGZsYWdzIGZvciBvcGVuaW5n
IHJlYWwgZGlyZWN0b3J5IikKVGVzdGVkLWJ5OiBFZHZhcmQgQ29ucmFkIDxlZHZhcmRAdHV0YS5p
bz4KTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1A1SW55NDEtLUYtOUB0dXRhLmlv
LwpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVp
biA8YW1pcjczaWxAZ21haWwuY29tPgotLS0KIGZzL29wZW4uYyAgICAgICAgICAgICAgICB8ICAx
ICsKIGZzL292ZXJsYXlmcy9vdmVybGF5ZnMuaCB8ICA5ICsrKysrKysrLQogZnMvb3ZlcmxheWZz
L3JlYWRkaXIuYyAgIHwgMjAgKysrKysrKysrKysrLS0tLS0tLS0KIGZzL292ZXJsYXlmcy91dGls
LmMgICAgICB8IDExICsrKysrKysrKystCiA0IGZpbGVzIGNoYW5nZWQsIDMxIGluc2VydGlvbnMo
KyksIDEwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL29wZW4uYyBiL2ZzL29wZW4uYwpp
bmRleCBlNDNmMDJmZjY0YWNiLi5iYjQ4NGIwNzM5MGFjIDEwMDY0NAotLS0gYS9mcy9vcGVuLmMK
KysrIGIvZnMvb3Blbi5jCkBAIC0xMTcyLDYgKzExNzIsNyBAQCBzdHJ1Y3QgZmlsZSAqZGVudHJ5
X29wZW5fbm9ub3RpZnkoY29uc3Qgc3RydWN0IHBhdGggKnBhdGgsIGludCBmbGFncywKIAl9CiAJ
cmV0dXJuIGY7CiB9CitFWFBPUlRfU1lNQk9MX0dQTChkZW50cnlfb3Blbl9ub25vdGlmeSk7CiAK
IC8qKgogICoga2VybmVsX2ZpbGVfb3BlbiAtIG9wZW4gYSBmaWxlIGZvciBrZXJuZWwgaW50ZXJu
YWwgdXNlCmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvb3ZlcmxheWZzLmggYi9mcy9vdmVybGF5
ZnMvb3ZlcmxheWZzLmgKaW5kZXggZTkzODlhMTA0NTJlOC4uYjVhNjcyZThlNDc2NCAxMDA2NDQK
LS0tIGEvZnMvb3ZlcmxheWZzL292ZXJsYXlmcy5oCisrKyBiL2ZzL292ZXJsYXlmcy9vdmVybGF5
ZnMuaApAQCAtNTMxLDcgKzUzMSwxNCBAQCB2b2lkIG92bF9kaXJfbW9kaWZpZWQoc3RydWN0IGRl
bnRyeSAqZGVudHJ5LCBib29sIGltcHVyaXR5KTsKIHU2NCBvdmxfaW5vZGVfdmVyc2lvbl9nZXQo
c3RydWN0IGlub2RlICppbm9kZSk7CiBib29sIG92bF9pc193aGl0ZW91dChzdHJ1Y3QgZGVudHJ5
ICpkZW50cnkpOwogYm9vbCBvdmxfcGF0aF9pc193aGl0ZW91dChzdHJ1Y3Qgb3ZsX2ZzICpvZnMs
IGNvbnN0IHN0cnVjdCBwYXRoICpwYXRoKTsKLXN0cnVjdCBmaWxlICpvdmxfcGF0aF9vcGVuKGNv
bnN0IHN0cnVjdCBwYXRoICpwYXRoLCBpbnQgZmxhZ3MpOworc3RydWN0IGZpbGUgKm92bF9wYXRo
X29wZW5fcmVhbGZpbGUoY29uc3Qgc3RydWN0IGZpbGUgKnVzZXJfZmlsZSwKKwkJCQkgICAgY29u
c3Qgc3RydWN0IHBhdGggKnBhdGgsIGludCBmbGFncyk7CisKK3N0YXRpYyBpbmxpbmUgc3RydWN0
IGZpbGUgKm92bF9wYXRoX29wZW4oY29uc3Qgc3RydWN0IHBhdGggKnBhdGgsIGludCBmbGFncykK
K3sKKwlyZXR1cm4gb3ZsX3BhdGhfb3Blbl9yZWFsZmlsZShOVUxMLCBwYXRoLCBmbGFncyk7Cit9
CisKIGludCBvdmxfY29weV91cF9zdGFydChzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIGludCBmbGFn
cyk7CiB2b2lkIG92bF9jb3B5X3VwX2VuZChzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpOwogYm9vbCBv
dmxfYWxyZWFkeV9jb3BpZWRfdXAoc3RydWN0IGRlbnRyeSAqZGVudHJ5LCBpbnQgZmxhZ3MpOwpk
aWZmIC0tZ2l0IGEvZnMvb3ZlcmxheWZzL3JlYWRkaXIuYyBiL2ZzL292ZXJsYXlmcy9yZWFkZGly
LmMKaW5kZXggYjg2MjMwOWViYTRkMS4uZDUxYjI0ZTJiYmQ5YSAxMDA2NDQKLS0tIGEvZnMvb3Zl
cmxheWZzL3JlYWRkaXIuYworKysgYi9mcy9vdmVybGF5ZnMvcmVhZGRpci5jCkBAIC00Myw2ICs0
Myw3IEBAIHN0cnVjdCBvdmxfZGlyX2NhY2hlIHsKIAogc3RydWN0IG92bF9yZWFkZGlyX2RhdGEg
ewogCXN0cnVjdCBkaXJfY29udGV4dCBjdHg7CisJY29uc3Qgc3RydWN0IGZpbGUgKnVzZXJfZmls
ZTsKIAlzdHJ1Y3QgZGVudHJ5ICpkZW50cnk7CiAJYm9vbCBpc19sb3dlc3Q7CiAJc3RydWN0IHJi
X3Jvb3QgKnJvb3Q7CkBAIC0zNzcsNyArMzc4LDggQEAgc3RhdGljIGlubGluZSBpbnQgb3ZsX2Rp
cl9yZWFkKGNvbnN0IHN0cnVjdCBwYXRoICpyZWFscGF0aCwKIAlzdHJ1Y3QgZmlsZSAqcmVhbGZp
bGU7CiAJaW50IGVycjsKIAotCXJlYWxmaWxlID0gb3ZsX3BhdGhfb3BlbihyZWFscGF0aCwgT19S
RE9OTFkgfCBPX0xBUkdFRklMRSk7CisJcmVhbGZpbGUgPSBvdmxfcGF0aF9vcGVuX3JlYWxmaWxl
KHJkZC0+dXNlcl9maWxlLCByZWFscGF0aCwKKwkJCQkJICBPX1JET05MWSB8IE9fTEFSR0VGSUxF
KTsKIAlpZiAoSVNfRVJSKHJlYWxmaWxlKSkKIAkJcmV0dXJuIFBUUl9FUlIocmVhbGZpbGUpOwog
CkBAIC00MjEsMTMgKzQyMywxNCBAQCBzdGF0aWMgdm9pZCBvdmxfZGlyX3Jlc2V0KHN0cnVjdCBm
aWxlICpmaWxlKQogfQogCiBzdGF0aWMgaW50IG92bF9kaXJfcmVhZF9tZXJnZWQoc3RydWN0IGRl
bnRyeSAqZGVudHJ5LCBzdHJ1Y3QgbGlzdF9oZWFkICpsaXN0LAotCXN0cnVjdCByYl9yb290ICpy
b290KQorCXN0cnVjdCByYl9yb290ICpyb290LCBjb25zdCBzdHJ1Y3QgZmlsZSAqdXNlcl9maWxl
KQogewogCWludCBlcnI7CiAJc3RydWN0IHBhdGggcmVhbHBhdGg7CiAJc3RydWN0IG92bF9yZWFk
ZGlyX2RhdGEgcmRkID0gewogCQkuY3R4LmFjdG9yID0gb3ZsX2ZpbGxfbWVyZ2UsCiAJCS5jdHgu
Y291bnQgPSBJTlRfTUFYLAorCQkudXNlcl9maWxlID0gdXNlcl9maWxlLAogCQkuZGVudHJ5ID0g
ZGVudHJ5LAogCQkubGlzdCA9IGxpc3QsCiAJCS5yb290ID0gcm9vdCwKQEAgLTQ5OCw5ICs1MDEs
MTAgQEAgc3RhdGljIHN0cnVjdCBvdmxfZGlyX2NhY2hlICpvdmxfZGlyX2NhY2hlX2NoZWNrKHN0
cnVjdCBpbm9kZSAqaW5vZGUsCiAJcmV0dXJuIGNhY2hlOwogfQogCi1zdGF0aWMgc3RydWN0IG92
bF9kaXJfY2FjaGUgKm92bF9jYWNoZV9nZXQoc3RydWN0IGRlbnRyeSAqZGVudHJ5KQorc3RhdGlj
IHN0cnVjdCBvdmxfZGlyX2NhY2hlICpvdmxfZGlyX2NhY2hlX2dldChzdHJ1Y3QgZmlsZSAqZmls
ZSkKIHsKIAlpbnQgcmVzOworCXN0cnVjdCBkZW50cnkgKmRlbnRyeSA9IGZpbGUtPmZfcGF0aC5k
ZW50cnk7CiAJc3RydWN0IG92bF9kaXJfY2FjaGUgKmNhY2hlOwogCXN0cnVjdCBpbm9kZSAqaW5v
ZGUgPSBkX2lub2RlKGRlbnRyeSk7CiAKQEAgLTUyMSw3ICs1MjUsNyBAQCBzdGF0aWMgc3RydWN0
IG92bF9kaXJfY2FjaGUgKm92bF9jYWNoZV9nZXQoc3RydWN0IGRlbnRyeSAqZGVudHJ5KQogCUlO
SVRfTElTVF9IRUFEKCZjYWNoZS0+ZW50cmllcyk7CiAJY2FjaGUtPnJvb3QgPSBSQl9ST09UOwog
Ci0JcmVzID0gb3ZsX2Rpcl9yZWFkX21lcmdlZChkZW50cnksICZjYWNoZS0+ZW50cmllcywgJmNh
Y2hlLT5yb290KTsKKwlyZXMgPSBvdmxfZGlyX3JlYWRfbWVyZ2VkKGRlbnRyeSwgJmNhY2hlLT5l
bnRyaWVzLCAmY2FjaGUtPnJvb3QsIGZpbGUpOwogCWlmIChyZXMpIHsKIAkJb3ZsX2NhY2hlX2Zy
ZWUoJmNhY2hlLT5lbnRyaWVzKTsKIAkJa2ZyZWUoY2FjaGUpOwpAQCAtODY2LDE0ICs4NzAsMTMg
QEAgc3RhdGljIGludCBvdmxfaXRlcmF0ZV9yZWFsKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qg
ZGlyX2NvbnRleHQgKmN0eCkKIHN0YXRpYyBpbnQgb3ZsX2l0ZXJhdGVfbWVyZ2VkKHN0cnVjdCBm
aWxlICpmaWxlLCBzdHJ1Y3QgZGlyX2NvbnRleHQgKmN0eCkKIHsKIAlzdHJ1Y3Qgb3ZsX2Rpcl9m
aWxlICpvZCA9IGZpbGUtPnByaXZhdGVfZGF0YTsKLQlzdHJ1Y3QgZGVudHJ5ICpkZW50cnkgPSBm
aWxlLT5mX3BhdGguZGVudHJ5OwogCXN0cnVjdCBvdmxfY2FjaGVfZW50cnkgKnA7CiAJaW50IGVy
cjsKIAogCWlmICghb2QtPmNhY2hlKSB7CiAJCXN0cnVjdCBvdmxfZGlyX2NhY2hlICpjYWNoZTsK
IAotCQljYWNoZSA9IG92bF9jYWNoZV9nZXQoZGVudHJ5KTsKKwkJY2FjaGUgPSBvdmxfZGlyX2Nh
Y2hlX2dldChmaWxlKTsKIAkJaWYgKElTX0VSUihjYWNoZSkpCiAJCQlyZXR1cm4gUFRSX0VSUihj
YWNoZSk7CiAKQEAgLTk5NCw3ICs5OTcsOCBAQCBzdGF0aWMgc3RydWN0IGZpbGUgKm92bF9kaXJf
b3Blbl9yZWFsZmlsZShjb25zdCBzdHJ1Y3QgZmlsZSAqZmlsZSwKIAkJCQkJICBjb25zdCBzdHJ1
Y3QgcGF0aCAqcmVhbHBhdGgpCiB7CiAJd2l0aF9vdmxfY3JlZHMoZmlsZV9pbm9kZShmaWxlKS0+
aV9zYikKLQkJcmV0dXJuIG92bF9wYXRoX29wZW4ocmVhbHBhdGgsIE9fUkRPTkxZIHwgKGZpbGUt
PmZfZmxhZ3MgJiBPX0xBUkdFRklMRSkpOworCQlyZXR1cm4gb3ZsX3BhdGhfb3Blbl9yZWFsZmls
ZShmaWxlLCByZWFscGF0aCwKKwkJCQkJICAgICAgT19SRE9OTFkgfCAoZmlsZS0+Zl9mbGFncyAm
IE9fTEFSR0VGSUxFKSk7CiB9CiAKIC8qCkBAIC0xMTE5LDcgKzExMjMsNyBAQCBpbnQgb3ZsX2No
ZWNrX2VtcHR5X2RpcihzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIHN0cnVjdCBsaXN0X2hlYWQgKmxp
c3QpCiAJc3RydWN0IHJiX3Jvb3Qgcm9vdCA9IFJCX1JPT1Q7CiAKIAl3aXRoX292bF9jcmVkcyhk
ZW50cnktPmRfc2IpCi0JCWVyciA9IG92bF9kaXJfcmVhZF9tZXJnZWQoZGVudHJ5LCBsaXN0LCAm
cm9vdCk7CisJCWVyciA9IG92bF9kaXJfcmVhZF9tZXJnZWQoZGVudHJ5LCBsaXN0LCAmcm9vdCwg
TlVMTCk7CiAJaWYgKGVycikKIAkJcmV0dXJuIGVycjsKIApkaWZmIC0tZ2l0IGEvZnMvb3Zlcmxh
eWZzL3V0aWwuYyBiL2ZzL292ZXJsYXlmcy91dGlsLmMKaW5kZXggNmMzZmRhMDQ3Zjk0Zi4uNzg4
YzY4NzBkNjdkZiAxMDA2NDQKLS0tIGEvZnMvb3ZlcmxheWZzL3V0aWwuYworKysgYi9mcy9vdmVy
bGF5ZnMvdXRpbC5jCkBAIC02NTQsNyArNjU0LDggQEAgYm9vbCBvdmxfcGF0aF9pc193aGl0ZW91
dChzdHJ1Y3Qgb3ZsX2ZzICpvZnMsIGNvbnN0IHN0cnVjdCBwYXRoICpwYXRoKQogCQlvdmxfcGF0
aF9jaGVja194d2hpdGVvdXRfeGF0dHIob2ZzLCBwYXRoKTsKIH0KIAotc3RydWN0IGZpbGUgKm92
bF9wYXRoX29wZW4oY29uc3Qgc3RydWN0IHBhdGggKnBhdGgsIGludCBmbGFncykKK3N0cnVjdCBm
aWxlICpvdmxfcGF0aF9vcGVuX3JlYWxmaWxlKGNvbnN0IHN0cnVjdCBmaWxlICp1c2VyX2ZpbGUs
CisJCQkJICAgIGNvbnN0IHN0cnVjdCBwYXRoICpwYXRoLCBpbnQgZmxhZ3MpCiB7CiAJc3RydWN0
IGlub2RlICppbm9kZSA9IGRfaW5vZGUocGF0aC0+ZGVudHJ5KTsKIAljb25zdCBzdHJ1Y3QgbW50
X2lkbWFwICpyZWFsX2lkbWFwID0gbW50X2lkbWFwKHBhdGgtPm1udCk7CkBAIC02ODIsNiArNjgz
LDE0IEBAIHN0cnVjdCBmaWxlICpvdmxfcGF0aF9vcGVuKGNvbnN0IHN0cnVjdCBwYXRoICpwYXRo
LCBpbnQgZmxhZ3MpCiAJaWYgKGlub2RlX293bmVyX29yX2NhcGFibGUocmVhbF9pZG1hcCwgaW5v
ZGUpKQogCQlmbGFncyB8PSBPX05PQVRJTUU7CiAKKwkvKgorCSAqIERpcmVjdG9yeSBvcGVucyB1
c2UgZGVudHJ5X29wZW4oKSBoZXJlLCBub3QgYmFja2luZ19maWxlX29wZW4oKS4KKwkgKiBJbmhl
cml0IEZNT0RFX05PTk9USUZZIGZyb20gYSBmYW5vdGlmeSBwZXJtaXNzaW9uIGZkIHNvIGEgbGlz
dGVuZXIKKwkgKiB0aGF0IGFsc28gd2F0Y2hlcyB0aGUgcmVhbCBmaWxlc3lzdGVtIGRvZXMgbm90
IGRlYWRsb2NrLgorCSAqLworCWlmICh1c2VyX2ZpbGUgJiYgRk1PREVfRlNOT1RJRllfTk9ORSh1
c2VyX2ZpbGUtPmZfbW9kZSkpCisJCXJldHVybiBkZW50cnlfb3Blbl9ub25vdGlmeShwYXRoLCBm
bGFncywgY3VycmVudF9jcmVkKCkpOworCiAJcmV0dXJuIGRlbnRyeV9vcGVuKHBhdGgsIGZsYWdz
LCBjdXJyZW50X2NyZWQoKSk7CiB9CiAKLS0gCjIuNTUuMAoK
--0000000000005c4f71065f4a5edd--
