Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9331D24EABC;
	Fri,  6 Jun 2025 07:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749194622; cv=none; b=czVcvvBECfrLmwhVgiPlXnKMkr3jdHkhIAI5TGjxUactlrG0zUZuN+KOxb0y4gbD9ZSyLFVTk7azHLGx6Sr/1QeZCF4oQI8hzAP8IgwzHy7Rik5T563sIq//vSqUzrnEHItDkAd4dvAmMh0DMgPsDKq7VfGaVCKKZcJeTFPEl3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749194622; c=relaxed/simple;
	bh=oxhqFwSDTF8M4a6vNQ7DguBA5noSoiOQBslF2mArsOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ib881Wme0LjNenswX4KA/Vff5BCqlwWj+GtBT34kGfzBEyuMec41n1CiPDuArYqfsblhIQM+1PR0xov6WTEi2v99UGLbsMJXLlTHR98hMWKW5oRsFt/KuMlu8p1zie9yepAoXf5OA3gZEkYeUwG8tlTEh5d65xa/jsLBkJOKnP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gu2EpcZn; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gu2EpcZn"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-60766191202so1261108a12.1;
        Fri, 06 Jun 2025 00:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749194619; x=1749799419; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V8/7ikf28rMiVd/A+RTwj3YheLrl5lqUjWzBM5dHf7A=;
        b=Gu2EpcZnEPh/gcxXEsMEecRR9gT+yxe+6eeClHOyfzffjIhl/BqibWcAjYc9Qm7GXj
         zqTPtsoZc8a9X5tcTs9nlV2lkIrHD3eCf/lxtgPOeIb+cMFpdZdj9T51Y/hfqpAMghHL
         LIK1TIU/3ZWFDsBt44imr2bEhflzdvc0DAJLOY2L7unIcD+uOATw55J2tAt5Viju1BB6
         mGbTusPKHsFObm3FFWdVtuKZuhpdyKFY9UNGCjeex9Hn+ekhmLcYjjwpyKuC6LfXHsyu
         i+etMG1+lqUNnfbi4D3c1Kvj+ZwZfNau8n/5Sa7K+2u5X96wey+2LyddR9mR0gmWHyp9
         29bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749194619; x=1749799419;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V8/7ikf28rMiVd/A+RTwj3YheLrl5lqUjWzBM5dHf7A=;
        b=QrMGR1bM9nNs8M0oMWMTj0oVbw56VUZcxUoP6r8gUeUml9ysgK0JeKz/bV18BhoEfk
         oVKiB5/WkKxBsg1vk8G0f1akD1Fksu4EU6W3hmpWohKTf/TIdjHlNvb/E4ni0FyxrFo8
         +L3DYHixSJU+tekuE/Nz/4SLxM6YPv+DFQarrYzCwgqxHOv3r4q4dCtoMafVbqweVZU3
         XG2XTCEOP2Hh0wmFkkTF9/hpQZRcLL3lwfZ/3Z9vCx6Sed+NZRQVPYgkhpmzjurgOAvO
         +5yU2YLY+894zAF8tYf8VRe44fbOQ07SimvTagXpIrWuu1uDXoHGPFIvaK2JVt1H+H7P
         ctnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZ6BSotNHnbsYQ1jJ6dmhmXIJywp+dppiyxo9QJX1Wx+PZdh8BJAEJIGqJ3Sk4m6DSTcldCV8b@vger.kernel.org, AJvYcCXy2I87Bc9vZsdgBUIPEl0pUNiNyF4Yt91AMPwodfpSgw+rFUx1PScLzBSLGiUexgikFLseLDpbhk6o1vk6Uw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwyN41tEvfUi6RGRLWnTEwsjoxljp4BplaI2nXq8wXhDpwaYmgQ
	FctcmVta8GsJF4uCfUVhHSwHaW3474qoa7huDWz7SY0WuDt2xFVOMwYcm0UnLsXzpdTeaM1/5pS
	5sxv7YhY2s4A4QPp6y88fgnNib+td4jg=
X-Gm-Gg: ASbGncu4cxiJX7eQ/518bHy1T650sgBQCVbbJBmRPkaMePXYGfLpf5u+qnC0BnqFPvO
	9HsHiXtifhPWdde3j9yZ680NTHMDx8T3zhIxEEueQvZgOERGdFWTZD5IfZ8tcIfaUmiu8x/KbpI
	jcZ9OUnVhNs9cCJfr/NS9/SL9LPU39OVLsr+sdssTWZnI=
X-Google-Smtp-Source: AGHT+IFkL1gqjXw9SGtwmJkYISz6AkEJnRogJCUpO4pq7FaNisj2ilSlCr59jzPTr0IjlkcCg2yYgvmSP5sMjHzpXkw=
X-Received: by 2002:a17:907:3f24:b0:ad5:43eb:d927 with SMTP id
 a640c23a62f3a-ade1a909706mr201675766b.23.1749194618269; Fri, 06 Jun 2025
 00:23:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603100745.2022891-1-amir73il@gmail.com> <20250603100745.2022891-5-amir73il@gmail.com>
 <20250605173233.ndqsjo77ds3e35p5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgQi6ciXtoKV7Nrw5_ECBOwS_m8h2KXT-ieJ4x4t04qag@mail.gmail.com> <20250606014531.d5t4gwx4iymqiqlo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250606014531.d5t4gwx4iymqiqlo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Jun 2025 09:23:26 +0200
X-Gm-Features: AX0GCFt0B9iYGgBFTZsNmG-xQD_zmMHOYmh1ZZ_3O-DtM-ImXF9q_FAGtt13tJI
Message-ID: <CAOQ4uxj_rshiLUUrCVS6RO+KhCeLrrgxNH+me3K38Nhc0Byqzw@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] generic/623: do not run with overlayfs
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000ddb7350636e21b9b"

--000000000000ddb7350636e21b9b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 3:45=E2=80=AFAM Zorro Lang <zlang@redhat.com> wrote:
>
> On Thu, Jun 05, 2025 at 08:38:30PM +0200, Amir Goldstein wrote:
> > On Thu, Jun 5, 2025 at 7:32=E2=80=AFPM Zorro Lang <zlang@redhat.com> wr=
ote:
> > >
> > > On Tue, Jun 03, 2025 at 12:07:43PM +0200, Amir Goldstein wrote:
> > > > This test performs shutdown via xfs_io -c shutdown.
> > > >
> > > > Overlayfs tests can use _scratch_shutdown, but they cannot use
> > > > "-c shutdown" xfs_io command without jumping through hoops, so by
> > > > default we do not support it.
> > > >
> > > > Add this condition to _require_xfs_io_command and add the require
> > > > statement to test generic/623 so it wont run with overlayfs.
> > > >
> > > > Reported-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > > > Tested-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > > > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-23=
50b1493d94@igalia.com/
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >  common/rc         | 8 ++++++++
> > > >  tests/generic/623 | 1 +
> > > >  2 files changed, 9 insertions(+)
> > > >
> > > > diff --git a/common/rc b/common/rc
> > > > index d8ee8328..bffd576a 100644
> > > > --- a/common/rc
> > > > +++ b/common/rc
> > > > @@ -3033,6 +3033,14 @@ _require_xfs_io_command()
> > > >               touch $testfile
> > > >               testio=3D`$XFS_IO_PROG -c "syncfs" $testfile 2>&1`
> > > >               ;;
> > > > +     "shutdown")
> > > > +             if [ $FSTYP =3D "overlay" ]; then
> > > > +                     # Overlayfs tests can use _scratch_shutdown, =
but they
> > > > +                     # cannot use "-c shutdown" xfs_io command wit=
hout jumping
> > > > +                     # through hoops, so by default we do not supp=
ort it.
> > > > +                     _notrun "xfs_io $command not supported on $FS=
TYP"
> > > > +             fi
> > > > +             ;;
> > >
> > > Hmm... I'm not sure this's a good way.
> > > For example, overlay/087 does xfs_io shutdown too,
> >
> > Yes it does but look at the effort needed to do that properly:
> >
> > $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f
> > ' -c close -c syncfs $SCRATCH_MNT | \
> >         grep -vF '[00'
> >
> > > generally it should calls
> > > _require_xfs_io_command "shutdown" although it doesn't. If someone ov=
erlay
> > > test case hope to test as o/087 does, and it calls _require_xfs_io_co=
mmand "shutdown",
> > > then it'll be _notrun.
> >
> > If someone knows enough to perform the dance above with _scratch_shutdo=
wn_handle
> > then that someone should know enough not to call
> > _require_xfs_io_command "shutdown".
> > OTOH, if someone doesn't know then default is to not run.
>
> Sure, I can understand that, just this logic is a bit *obscure* :) It sou=
nds like:
> "If an overlay test case wants to do xfs_io shutdown, it shouldn't call
> _require_xfs_io_command "shutdown". Or call that to skip a shutdown test
> on overlay :)"
>
> And the expected result of _require_xfs_io_command "shutdown" will be tot=
ally
> opposite with _require_scratch_shutdown on overlay, that might be confuse=
d.
> Can we have a clearer way to deal with that?
>

I don't really understand the confusion.

_require_xfs_io_command "shutdown"

Like any other _require statement
requires support for what this test does -
meaning that a test does xfs_io -c shutdown, just like test generic/623 doe=
s

and _require_scratch_shutdown implies that the test does
_scratch_shutdown

FSTYP overlay happens to be able to do _scratch_shutdown
but not able to do xfs_io -c shutdown $SCRATCH_MNT

The different _require statements simply reflect reality as it is.

We can solve the confused about o/087 not having
_require_xfs_io_command "shutdown"
by moving the special hand crafted xfs_io command in o/087
to a helper _scratch_shutdown_and_syncfs to hide those internal
implementation details from test writers.
See attached patch.

Thanks,
Amir.

--000000000000ddb7350636e21b9b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-fstests-add-helper-_scratch_shutdown_and_syncfs.patch"
Content-Disposition: attachment; 
	filename="0001-fstests-add-helper-_scratch_shutdown_and_syncfs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mbkh9qf20>
X-Attachment-Id: f_mbkh9qf20

RnJvbSAzYjRkNmZmM2NlOTA5ZmE0YjM4NWE4ZDA3NWJiYWMxZjMyYjgyY2I4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBGcmksIDYgSnVuIDIwMjUgMDk6MTE6MTcgKzAyMDAKU3ViamVjdDogW1BBVENIXSBmc3Rl
c3RzOiBhZGQgaGVscGVyIF9zY3JhdGNoX3NodXRkb3duX2FuZF9zeW5jZnMKClRlc3QgeGZzLzU0
NiBoYXMgdG8gY2hhaW4gc3luY2ZzIGFmdGVyIHNodXRkb3duIGFuZCBjYW5ub3QKdXNlIHRoZSBf
c2NyYXRjaF9zaGl0ZG93biBoZWxwZXIsIGJlY2F1c2UgYWZ0ZXIgc2h1dGRvd24gYSBmZApjYW5u
b3QgYmUgb3BlbmVkIHRvIGV4ZWN1dGUgc3luY2ZzIG9uLgoKVGhlIHhmc19pbyBjb21tYW5kIG9m
IGNoYWluaW5nIHN5bmNmcyBhZnRlciBzaHV0ZG93biBpcyByYXRoZXIKbW9yZSBjb21wbGV4IHRv
IGV4ZWN1dGUgaW4gdGhlIGRlcml2ZWQgb3ZlcmxheWZzIHRlc3Qgb3ZlcmxheS8wODcuCgpBZGQg
YSBoZWxwZXIgdG8gYWJzdHJhY3QgdGhpcyBjb21wbGV4aXR5IGZyb20gdGVzdCB3cml0ZXJzLgpB
ZGQgYSBfcmVxdWlyZSBzdGF0ZW1lbnQgdG8gbWF0Y2guCgpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdv
bGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgotLS0KIGNvbW1vbi9yYyAgICAgICAgIHwgMjcg
KysrKysrKysrKysrKysrKysrKysrKysrKysrCiB0ZXN0cy9vdmVybGF5LzA4NyB8IDEzICsrKy0t
LS0tLS0tLS0KIHRlc3RzL3hmcy81NDYgICAgIHwgIDUgKystLS0KIDMgZmlsZXMgY2hhbmdlZCwg
MzIgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvY29tbW9uL3Jj
IGIvY29tbW9uL3JjCmluZGV4IDk2ZDY1ZDFjLi43NzY4M2I4MiAxMDA2NDQKLS0tIGEvY29tbW9u
L3JjCisrKyBiL2NvbW1vbi9yYwpAQCAtNTk1LDYgKzU5NSwyNyBAQCBfc2NyYXRjaF9zaHV0ZG93
bl9oYW5kbGUoKQogCWZpCiB9CiAKK19zY3JhdGNoX3NodXRkb3duX2FuZF9zeW5jZnMoKQorewor
CWlmIFsgJEZTVFlQID0gIm92ZXJsYXkiIF07IHRoZW4KKwkJIyBJbiBsYWdhY3kgb3ZlcmxheSB1
c2FnZSwgaXQgbWF5IHNwZWNpZnkgZGlyZWN0b3J5IGFzCisJCSMgU0NSQVRDSF9ERVYsIGluIHRo
aXMgY2FzZSBPVkxfQkFTRV9TQ1JBVENIX0RFVgorCQkjIHdpbGwgYmUgbnVsbCwgc28gY2hlY2sg
T1ZMX0JBU0VfU0NSQVRDSF9ERVYgYmVmb3JlCisJCSMgcnVubmluZyBzaHV0ZG93biB0byBhdm9p
ZCBzaHV0dGluZyBkb3duIGJhc2UgZnMgYWNjaWRlbnRseS4KKwkJaWYgWyAteiAkT1ZMX0JBU0Vf
U0NSQVRDSF9ERVYgXTsgdGhlbgorCQkJX2ZhaWwgIl9zY3JhdGNoX3NodXRkb3duOiBjYWxsIF9y
ZXF1aXJlX3NjcmF0Y2hfc2h1dGRvd24gZmlyc3QgaW4gdGVzdCIKKwkJZmkKKwkJIyBUaGlzIGNv
bW1hbmQgaXMgY29tcGxpY2F0ZWQgYSBiaXQgYmVjYXVzZSBpbiB0aGUgY2FzZSBvZiBvdmVybGF5
ZnMgdGhlCisJCSMgc3luY2ZzIGZkIG5lZWRzIHRvIGJlIG9wZW5lZCBiZWZvcmUgc2h1dGRvd24g
YW5kIGl0IGlzIGRpZmZlcmVudCBmcm9tIHRoZQorCQkjIHNodXRkb3duIGZkLCBzbyB3ZSBjYW5u
b3QgdXNlIHRoZSBfc2NyYXRjaF9zaHV0ZG93bigpIGhlbHBlci4KKwkJIyBGaWx0ZXIgb3V0IHhm
c19pbyBvdXRwdXQgb2YgYWN0aXZlIGZkcy4KKwkJJFhGU19JT19QUk9HIC14IC1jICJvcGVuICQo
X3NjcmF0Y2hfc2h1dGRvd25faGFuZGxlKSIgLWMgJ3NodXRkb3duIC1mICcgXAorCQkJCS1jIGNs
b3NlIC1jIHN5bmNmcyAkU0NSQVRDSF9NTlQgfCBncmVwIC12RiAnWzAwJworCWVsc2UKKwkJJFhG
U19JT19QUk9HIC14IC1jICdzaHV0ZG93biAtZiAnIC1jIHN5bmNmcyAkU0NSQVRDSF9NTlQKKwlm
aQorfQorCiBfbW92ZV9tb3VudCgpCiB7CiAJbG9jYWwgbW50PSQxCkBAIC00MTEwLDYgKzQxMzEs
MTIgQEAgX3JlcXVpcmVfc2NyYXRjaF9zaHV0ZG93bigpCiAJX3NjcmF0Y2hfdW5tb3VudAogfQog
CitfcmVxdWlyZV9zY3JhdGNoX3NodXRkb3duX2FuZF9zeW5jZnMoKQoreworCV9yZXF1aXJlX3hm
c19pb19jb21tYW5kIHN5bmNmcworCV9yZXF1aXJlX3NjcmF0Y2hfc2h1dGRvd24KK30KKwogX2No
ZWNrX3NfZGF4KCkKIHsKIAlsb2NhbCB0YXJnZXQ9JDEKZGlmZiAtLWdpdCBhL3Rlc3RzL292ZXJs
YXkvMDg3IGIvdGVzdHMvb3ZlcmxheS8wODcKaW5kZXggYTVhZmIwZDUuLjJhZDA2OWRiIDEwMDc1
NQotLS0gYS90ZXN0cy9vdmVybGF5LzA4NworKysgYi90ZXN0cy9vdmVybGF5LzA4NwpAQCAtMzIs
OSArMzIsOCBAQCBfYmVnaW5fZnN0ZXN0IGF1dG8gcXVpY2sgbW91bnQgc2h1dGRvd24KIAogCiAj
IE1vZGlmeSBhcyBhcHByb3ByaWF0ZS4KLV9yZXF1aXJlX3hmc19pb19jb21tYW5kIHN5bmNmcwog
X3JlcXVpcmVfc2NyYXRjaF9ub2NoZWNrCi1fcmVxdWlyZV9zY3JhdGNoX3NodXRkb3duCitfcmVx
dWlyZV9zY3JhdGNoX3NodXRkb3duX2FuZF9zeW5jZnMKIAogWyAiJE9WTF9CQVNFX0ZTVFlQIiA9
PSAieGZzIiBdIHx8IFwKIAlfbm90cnVuICJiYXNlIGZzICRPVkxfQkFTRV9GU1RZUCBoYXMgdW5r
bm93biBiZWhhdmlvciB3aXRoIHN5bmNmcyBhZnRlciBzaHV0ZG93biIKQEAgLTQzLDE5ICs0Miwx
MyBAQCBfcmVxdWlyZV9zY3JhdGNoX3NodXRkb3duCiAjIGJvdGhlciBjaGVja2luZyB0aGUgZmls
ZXN5c3RlbSBhZnRlcndhcmRzIHNpbmNlIHdlIG5ldmVyIHdyb3RlIGFueXRoaW5nLgogZWNobyAi
PT09IHN5bmNmcyBhZnRlciBzaHV0ZG93biIKIF9zY3JhdGNoX21vdW50Ci0jIFRoaXMgY29tbWFu
ZCBpcyBjb21wbGljYXRlZCBhIGJpdCBiZWNhdXNlIGluIHRoZSBjYXNlIG9mIG92ZXJsYXlmcyB0
aGUKLSMgc3luY2ZzIGZkIG5lZWRzIHRvIGJlIG9wZW5lZCBiZWZvcmUgc2h1dGRvd24gYW5kIGl0
IGlzIGRpZmZlcmVudCBmcm9tIHRoZQotIyBzaHV0ZG93biBmZCwgc28gd2UgY2Fubm90IHVzZSB0
aGUgX3NjcmF0Y2hfc2h1dGRvd24oKSBoZWxwZXIuCi0jIEZpbHRlciBvdXQgeGZzX2lvIG91dHB1
dCBvZiBhY3RpdmUgZmRzLgotJFhGU19JT19QUk9HIC14IC1jICJvcGVuICQoX3NjcmF0Y2hfc2h1
dGRvd25faGFuZGxlKSIgLWMgJ3NodXRkb3duIC1mICcgLWMgY2xvc2UgLWMgc3luY2ZzICRTQ1JB
VENIX01OVCB8IFwKLQlncmVwIC12RiAnWzAwJworX3NjcmF0Y2hfc2h1dGRvd25fYW5kX3N5bmNm
cwogCiAjIE5vdyByZXBlYXQgdGhlIHNhbWUgdGVzdCB3aXRoIGEgdm9sYXRpbGUgb3ZlcmxheWZz
IG1vdW50IGFuZCBleHBlY3Qgbm8gZXJyb3IKIF9zY3JhdGNoX3VubW91bnQKIGVjaG8gIj09PSBz
eW5jZnMgYWZ0ZXIgc2h1dGRvd24gKHZvbGF0aWxlKSIKIF9zY3JhdGNoX21vdW50IC1vIHZvbGF0
aWxlCi0kWEZTX0lPX1BST0cgLXggLWMgIm9wZW4gJChfc2NyYXRjaF9zaHV0ZG93bl9oYW5kbGUp
IiAtYyAnc2h1dGRvd24gLWYgJyAtYyBjbG9zZSAtYyBzeW5jZnMgJFNDUkFUQ0hfTU5UIHwgXAot
CWdyZXAgLXZGICdbMDAnCitfc2NyYXRjaF9zaHV0ZG93bl9hbmRfc3luY2ZzCiAKICMgc3VjY2Vz
cywgYWxsIGRvbmUKIHN0YXR1cz0wCmRpZmYgLS1naXQgYS90ZXN0cy94ZnMvNTQ2IGIvdGVzdHMv
eGZzLzU0NgppbmRleCAzMTZmZmM1MC4uYzUwZDQxYTYgMTAwNzU1Ci0tLSBhL3Rlc3RzL3hmcy81
NDYKKysrIGIvdGVzdHMveGZzLzU0NgpAQCAtMjcsMTQgKzI3LDEzIEBAIF9iZWdpbl9mc3Rlc3Qg
YXV0byBxdWljayBzaHV0ZG93bgogCiAKICMgTW9kaWZ5IGFzIGFwcHJvcHJpYXRlLgotX3JlcXVp
cmVfeGZzX2lvX2NvbW1hbmQgc3luY2ZzCiBfcmVxdWlyZV9zY3JhdGNoX25vY2hlY2sKLV9yZXF1
aXJlX3NjcmF0Y2hfc2h1dGRvd24KK19yZXF1aXJlX3NjcmF0Y2hfc2h1dGRvd25fYW5kX3N5bmNm
cwogCiAjIFJldXNlIHRoZSBmcyBmb3JtYXR0ZWQgd2hlbiB3ZSBjaGVja2VkIGZvciB0aGUgc2h1
dGRvd24gaW9jdGwsIGFuZCBkb24ndAogIyBib3RoZXIgY2hlY2tpbmcgdGhlIGZpbGVzeXN0ZW0g
YWZ0ZXJ3YXJkcyBzaW5jZSB3ZSBuZXZlciB3cm90ZSBhbnl0aGluZy4KIF9zY3JhdGNoX21vdW50
Ci0kWEZTX0lPX1BST0cgLXggLWMgJ3NodXRkb3duIC1mICcgLWMgc3luY2ZzICRTQ1JBVENIX01O
VAorX3NjcmF0Y2hfc2h1dGRvd25fYW5kX3N5bmNmcwogCiAjIHN1Y2Nlc3MsIGFsbCBkb25lCiBz
dGF0dXM9MAotLSAKMi4zNC4xCgo=
--000000000000ddb7350636e21b9b--
