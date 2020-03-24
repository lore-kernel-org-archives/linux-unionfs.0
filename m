Return-Path: <SRS0=nA/m=5J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F11C10DCE
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Mar 2020 06:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9127120663
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Mar 2020 06:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gcgh6Pak"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgCXG1x (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 02:27:53 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:36823 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgCXG1x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Mar 2020 02:27:53 -0400
Received: by mail-il1-f195.google.com with SMTP id h3so15745583ils.3
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2020 23:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gtfZrv97NSONK/m3p5yoJef+O/wNoj0Uu9fYCDxq59s=;
        b=Gcgh6PakMbGLFB/BxRVqfNkjPBMlqtCTkGoxfaXG3AYVYcGyqbCaTnMrev1vFSMwCn
         HgBiXyBFE6AhVloM8zUuwybi9HJhsPt0thba8PtJgKvmf0UVrf+mMpxNqRPTDgaRzBtS
         P13M+y1YZTo4pIhKFa4CJcXotVaj7Z9hHR36tRo44LsBzBnyG2f9s8kfqA/AXrc8jA2o
         /uqb8yls3KSjHI0xaw++Rdh/97fA1a4Rrrz26WvqSm2j+y0sLpx8rWUX03Gbp3l3h6Iz
         2auUfWkpXRqqgywnAHhalGZaNuTiPChJU9BMe3MIwIf6Ypi6PwX/duTn2y2DK7oMz4dA
         sx7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gtfZrv97NSONK/m3p5yoJef+O/wNoj0Uu9fYCDxq59s=;
        b=SW1XRd1aodMkpx/J++oegc9P/d1I/7EdbSV286etd4IW8MHBV2QndYhu5IycTzi0ou
         ApiKMqokm/hbhEdbR8PquJMhv5jMBtIXPNPbsR7rF9utxAsferZ5NBHVb9guhK5v6NH2
         jiG5fTxgJ2/o2q/tsZc39P6xvQMQsBvc+4eRwwhh75/8Zy25bWKA1idBFRIR0Tjymdrh
         VWLtbnpXiqSLMTRRvUqtzkKKF6dl7GKxYQWc9m/8nMD5jLjx+ZU2bxn0UsJ8f8SORXeP
         9L1YE1yvm7ZvtHAtRTG/uHojImR7LqWzNVy5BcxHBslfqZiY9LpmSYYsfudCtNmO9xPK
         mwng==
X-Gm-Message-State: ANhLgQ1zPa1C1BesY2xcBZ4N7T45vWpWMomBALMHERgpt2zHvt5YdyQS
        6gT/z+n/JQMkc4jxQ8O0uWLNMK0sPWwtjNkYxi4=
X-Google-Smtp-Source: ADFU+vsli67qMdI20vs5m0uZLiRLYFs5dNsM7ONPmQsLHTVZoIMTU2M+LNL3EBOTyfuguOJcTV79zMVL6/1AX94EuOY=
X-Received: by 2002:a92:5b51:: with SMTP id p78mr24418862ilb.250.1585031271829;
 Mon, 23 Mar 2020 23:27:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAFkON1U3cXdXFQYdkoQ3OQU+14GX7C88U6qre58vyfhrrFgKXw@mail.gmail.com>
 <CAJfpegsv+GayCtWtsfJZYWqH8DHw76U_cGOuqofgt895FBj0cg@mail.gmail.com>
 <CAOQ4uxiW2-Hh_sfuYXeuQy=a6FYBm7DyWkysgEe1GnC-qWWivg@mail.gmail.com>
 <CAJfpegtCn-HLhuDB98G4dO8L-t2PMcqcwDw+0TiknU5LGvBacQ@mail.gmail.com>
 <CAJfpeguKujUqW-z75F+6mCh0uwHF6rz2cK4OWUCFe83QNmaSrQ@mail.gmail.com>
 <CAOQ4uxha8XSB62cq=+X-tCdMUnOTrYpJT1YbjxuLhmrFsRM-Pw@mail.gmail.com> <CAOQ4uxhEU=y=m49Vii=iRigXJ_ofhQ+me9QdF4kTFTMfMu_fpQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhEU=y=m49Vii=iRigXJ_ofhQ+me9QdF4kTFTMfMu_fpQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 24 Mar 2020 08:27:40 +0200
Message-ID: <CAOQ4uxjcKQkmPkza0K19YFwTzxBJmsoKC-3tktF1aAA0XOdkRQ@mail.gmail.com>
Subject: Re: Kernel warnings in fs/inode.c:302 drop_nlink+0x28/0x40
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Phasip <phasip@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ec2cc005a193d9a6"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--000000000000ec2cc005a193d9a6
Content-Type: text/plain; charset="UTF-8"

On Mon, Mar 23, 2020 at 9:15 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Mar 23, 2020 at 7:27 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Mar 23, 2020 at 4:53 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Mon, Mar 23, 2020 at 3:21 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Mon, Mar 23, 2020 at 2:24 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > > > IDGI. coming from vfs_unlink() and vfs_rename() it doesn't look like
> > > > > it is possible for victim inode not to have a hashed alias, so the
> > > > > alias test seems futile.
> > > >
> > > > Yeah, needs a comment: both ovl_remove_upper() and
> > > > ovl_remove_and_whiteout() unhash the dentry before returning, so
> > > > d_find_alias() will find another hashed dentry or none.
> > >
> > > Except that doesn't seem to be true for the overwriting rename case...
> > >
> > > Attached patch should work for both.
> > >
> >
> > It still looks quite hacky.
> > Why do we not look at upper->i_nlink in order to fix the situation?
> >
> > For index=on, there is already code to handle lower hardlink skew case,
> > including pr_warn and several xfstests (overlay/034 for example).
> > The check is buried in ovl_nlink_end() => ovl_cleanup_index().
> > It's keeping overlay i_nlink above upper i_nlink.
> >
> > In fact, if you change one line in overlay/034 it triggers the reported
> > bug, so we can just fork this test.
> >
> > -lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> > +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> >  workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> >
> > How about adding a check in ovl_nlink_start() to fix overlay i_nlink
> > below upper i_link?
> > It would be a valid check for both index=off and on.
> > I will try to write it up later.
> >
>
> https://lore.kernel.org/linux-unionfs/20200323190850.3091-1-amir73il@gmail.com/T/#u
>

Attached xfstest. I will post it once the kernel fix commit is finalized.

Thanks,
Amir.

--000000000000ec2cc005a193d9a6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-overlay-another-test-for-dropping-nlink-below-zero.patch"
Content-Disposition: attachment; 
	filename="0001-overlay-another-test-for-dropping-nlink-below-zero.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k85ionyq0>
X-Attachment-Id: f_k85ionyq0

RnJvbSAzN2M5ZjcxZjNkYWNkMmZlMDgxMWU3Mjc4ZjEzNzc1YzU1ZTNlODU0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDI0IE1hciAyMDIwIDA4OjEyOjQyICswMjAwClN1YmplY3Q6IFtQQVRDSF0gb3Zl
cmxheTogYW5vdGhlciB0ZXN0IGZvciBkcm9wcGluZyBubGluayBiZWxvdyB6ZXJvCgpUaGlzIGlz
IGEgdmFyaWFudCBvbiB0ZXN0IG92ZXJsYXkvMDM0LgoKVGhpcyB2YXJpYW50IGlzIG1hbmdsaW5n
IHVwcGVyIGhhcmRsaW5rcyBpbnN0ZWFkIG9mIGxvd2VyIGhhcmRsaW5rcwphbmQgZG9lcyBub3Qg
cmVxdWlyZSB0aGUgaW5vZGVzIGluZGV4IGZlYXR1cmUuCgpUaGlzIGlzIGEgcmVncmVzc2lvbiB0
ZXN0IGZvciBrZXJuZWwgY29tbWl0OgooIm92bDogZml4IFdBUk5fT04gbmxpbmsgZHJvcCB0byB6
ZXJvIikKClNpZ25lZC1vZmYtYnk6IEFtaXIgR29sZHN0ZWluIDxhbWlyNzNpbEBnbWFpbC5jb20+
Ci0tLQogdGVzdHMvb3ZlcmxheS8wNzIgICAgIHwgODUgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKwogdGVzdHMvb3ZlcmxheS8wNzIub3V0IHwgIDIgKwogdGVzdHMv
b3ZlcmxheS9ncm91cCAgIHwgIDEgKwogMyBmaWxlcyBjaGFuZ2VkLCA4OCBpbnNlcnRpb25zKCsp
CiBjcmVhdGUgbW9kZSAxMDA3NTUgdGVzdHMvb3ZlcmxheS8wNzIKIGNyZWF0ZSBtb2RlIDEwMDY0
NCB0ZXN0cy9vdmVybGF5LzA3Mi5vdXQKCmRpZmYgLS1naXQgYS90ZXN0cy9vdmVybGF5LzA3MiBi
L3Rlc3RzL292ZXJsYXkvMDcyCm5ldyBmaWxlIG1vZGUgMTAwNzU1CmluZGV4IDAwMDAwMDAwLi5l
OGEzNzhlNAotLS0gL2Rldi9udWxsCisrKyBiL3Rlc3RzL292ZXJsYXkvMDcyCkBAIC0wLDAgKzEs
ODUgQEAKKyMhIC9iaW4vYmFzaAorIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAor
IyBDb3B5cmlnaHQgKEMpIDIwMjAgQ1RFUkEgTmV0d29ya3MuIEFsbCBSaWdodHMgUmVzZXJ2ZWQu
CisjCisjIEZTIFFBIFRlc3QgMDcyCisjCisjIFRlc3Qgb3ZlcmxheSBubGluayB3aGVuIGFkZGlu
ZyB1cHBlciBoYXJkbGlua3MuCisjCisjIG5saW5rIG9mIG92ZXJsYXkgaW5vZGUgY291bGQgYmUg
ZHJvcHBlZCBpbmRlZmluaXRlbHkgYnkgYWRkaW5nCisjIHVuYWNjb3VudGVkIHVwcGVyIGhhcmRs
aW5rcyB1bmRlcm5lYXRoIGEgbW91bnRlZCBvdmVybGF5IGFuZAorIyB0cnlpbmcgdG8gcmVtb3Zl
IHRoZW0uCisjCisjIFRoaXMgaXMgYSB2YXJpYW50IG9mIHRlc3Qgb3ZlcmxheS8wMzQgd2l0aCBt
YW5nbGluZyBvZiB1cHBlciBpbnN0ZWFkCisjIG9mIGxvd2VyIGhhcmRsaW5rcy4gVW5saWtlIG92
ZXJsYXkvMDM0LCB0aGlzIHRlc3QgZG9lcyBub3QgcmVxdWlyZSB0aGUKKyMgaW5vZGUgaW5kZXgg
ZmVhdHVyZSBhbmQgd2lsbCBwYXNzIHdoZXRoZXIgaXMgaXQgZW5hYmxlZCBvciBkaXNhYmxlZAor
IyBieSBkZWZhdWx0LgorIworIyBUaGlzIGlzIGEgcmVncmVzc2lvbiB0ZXN0IGZvciBrZXJuZWwg
Y29tbWl0OgorIyAoIm92bDogZml4IFdBUk5fT04gbmxpbmsgZHJvcCB0byB6ZXJvIikuCisjIFdp
dGhvdXQgdGhlIGZpeCwgdGhlIHRlc3QgdHJpZ2dlcnMKKyMgV0FSTl9PTihpbm9kZS0+aV9ubGlu
ayA9PSAwKSBpbiBkcm9wX2xpbmsoKS4KKyMKK3NlcT1gYmFzZW5hbWUgJDBgCitzZXFyZXM9JFJF
U1VMVF9ESVIvJHNlcQorZWNobyAiUUEgb3V0cHV0IGNyZWF0ZWQgYnkgJHNlcSIKKwordG1wPS90
bXAvJCQKK3N0YXR1cz0xCSMgZmFpbHVyZSBpcyB0aGUgZGVmYXVsdCEKK3RyYXAgIl9jbGVhbnVw
OyBleGl0IFwkc3RhdHVzIiAwIDEgMiAzIDE1CisKK19jbGVhbnVwKCkKK3sKKwljZCAvCisJcm0g
LWYgJHRtcC4qCit9CisKKyMgZ2V0IHN0YW5kYXJkIGVudmlyb25tZW50LCBmaWx0ZXJzIGFuZCBj
aGVja3MKKy4gLi9jb21tb24vcmMKKy4gLi9jb21tb24vZmlsdGVyCisKKyMgcmVtb3ZlIHByZXZp
b3VzICRzZXFyZXMuZnVsbCBiZWZvcmUgdGVzdAorcm0gLWYgJHNlcXJlcy5mdWxsCisKKyMgcmVh
bCBRQSB0ZXN0IHN0YXJ0cyBoZXJlCitfc3VwcG9ydGVkX2ZzIG92ZXJsYXkKK19zdXBwb3J0ZWRf
b3MgTGludXgKK19yZXF1aXJlX3NjcmF0Y2gKKwordXBwZXJkaXI9JE9WTF9CQVNFX1NDUkFUQ0hf
TU5ULyRPVkxfVVBQRVIKKworIyBSZW1vdmUgYWxsIGZpbGVzIGZyb20gcHJldmlvdXMgdGVzdHMK
K19zY3JhdGNoX21rZnMKKworIyBDcmVhdGUgbG93ZXIgaGFyZGxpbmsKK21rZGlyIC1wICR1cHBl
cmRpcgordG91Y2ggJHVwcGVyZGlyLzAKK2xuICR1cHBlcmRpci8wICR1cHBlcmRpci8xCisKK19z
Y3JhdGNoX21vdW50CisKKyMgQ29weSB1cCBsb3dlciBoYXJkbGluayAtIG92ZXJsYXkgaW5vZGUg
bmxpbmsgMiBpcyBjb3BpZWQgZnJvbSBsb3dlcgordG91Y2ggJFNDUkFUQ0hfTU5ULzAKKworIyBB
ZGQgbG93ZXIgaGFyZGxpbmtzIHdoaWxlIG92ZXJsYXkgaXMgbW91bnRlZCAtIG92ZXJsYXkgaW5v
ZGUgbmxpbmsKKyMgaXMgbm90IGJlaW5nIHVwZGF0ZWQKK2xuICR1cHBlcmRpci8wICR1cHBlcmRp
ci8yCitsbiAkdXBwZXJkaXIvMCAkdXBwZXJkaXIvMworCisjIFVubGluayB0aGUgMiB1bi1hY2Nv
dW50ZWQgbG93ZXIgaGFyZGxpbmtzIC0gb3ZlcmxheSBpbm9kZSBubGlua3MKKyMgZHJvcHMgMiBh
bmQgbWF5IHJlYWNoIDAgaWYgdGhlIHNpdHVhdGlvbiBpcyBub3QgZGV0ZWN0ZWQKK3JtICRTQ1JB
VENIX01OVC8yCitybSAkU0NSQVRDSF9NTlQvMworCisjIENoZWNrIGlmIGdldHRpbmcgRU5PRU5U
IHdoZW4gdHJ5aW5nIHRvIGxpbmsgIUlfTElOS0FCTEUgd2l0aCBubGluayAwCitsbiAkU0NSQVRD
SF9NTlQvMCAkU0NSQVRDSF9NTlQvNAorCisjIFVubGluayBhbGwgaGFyZGxpbmtzIC0gaWYgb3Zl
cmxheSBpbm9kZSBubGluayBpcyAwLCB0aGlzIHdpbGwgdHJpZ2dlcgorIyBXQVJOX09OKCkgaW4g
ZHJvcF9ubGluaygpCitybSAkU0NSQVRDSF9NTlQvMAorcm0gJFNDUkFUQ0hfTU5ULzEKK3JtICRT
Q1JBVENIX01OVC80CisKK2VjaG8gIlNpbGVuY2UgaXMgZ29sZGVuIgorc3RhdHVzPTAKK2V4aXQK
ZGlmZiAtLWdpdCBhL3Rlc3RzL292ZXJsYXkvMDcyLm91dCBiL3Rlc3RzL292ZXJsYXkvMDcyLm91
dApuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMC4uNTkwYmJjNmMKLS0tIC9kZXYv
bnVsbAorKysgYi90ZXN0cy9vdmVybGF5LzA3Mi5vdXQKQEAgLTAsMCArMSwyIEBACitRQSBvdXRw
dXQgY3JlYXRlZCBieSAwNzIKK1NpbGVuY2UgaXMgZ29sZGVuCmRpZmYgLS1naXQgYS90ZXN0cy9v
dmVybGF5L2dyb3VwIGIvdGVzdHMvb3ZlcmxheS9ncm91cAppbmRleCA0M2FkOGE1Mi4uODI4NzZk
MDkgMTAwNjQ0Ci0tLSBhL3Rlc3RzL292ZXJsYXkvZ3JvdXAKKysrIGIvdGVzdHMvb3ZlcmxheS9n
cm91cApAQCAtNzQsMyArNzQsNCBAQAogMDY5IGF1dG8gcXVpY2sgY29weXVwIGhhcmRsaW5rIGV4
cG9ydGZzIG5lc3RlZCBub25zYW1lZnMKIDA3MCBhdXRvIHF1aWNrIGNvcHl1cCByZWRpcmVjdCBu
ZXN0ZWQKIDA3MSBhdXRvIHF1aWNrIGNvcHl1cCByZWRpcmVjdCBuZXN0ZWQgbm9uc2FtZWZzCisw
NzIgYXV0byBxdWljayBjb3B5dXAgaGFyZGxpbmsKLS0gCjIuMTcuMQoK
--000000000000ec2cc005a193d9a6--
