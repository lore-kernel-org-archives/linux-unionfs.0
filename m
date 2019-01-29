Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
 <CAOQ4uxj=c9F5NNBNm+ek3NOPPpj4bh86V6WQyN1N88e76QZWdg@mail.gmail.com>
 <CAJfpegusiOjWo-dR3eM0yBWeSE0QTaDwM0-kAoo=fSyuVJgZFQ@mail.gmail.com>
 <CAOQ4uxhgK0tanvqZn9a9=q80Sc4L3GO1Nou7amU51Q66uUXhOg@mail.gmail.com>
 <CAJfpegv48DRJ4Cd40gFX+ssmNmQTtej+8SNAtzCoPtjgBnws9Q@mail.gmail.com>
 <CAOQ4uxjStG-KYaTHcaheZYcPDq7it2c_82RePFnmSzfFND_--A@mail.gmail.com>
 <CAJfpeguv8gebY_7dhOtb7LrhYPW6x3=upqakMTa3f4VuRkEgpA@mail.gmail.com>
 <CAJfpegsVy=tep29H=zWhRYCVHBd4mYO=e_181DinZUQOaetoJA@mail.gmail.com>
 <CAOQ4uxha2VNZ-Da-w6U5yxrqA3PkixXPevk9_5NvMzg4-KkWSg@mail.gmail.com>
 <CAOQ4uxiKss89-J+Wv1q9QtvMMsypKFy-ktBom_Ss9kPr7_te6w@mail.gmail.com>
 <20190128192207.GA10240@redhat.com> <CAOQ4uxg7E=K6_RTd7-qKt6gPGiMx7S46ZYkCECzwEUmxzBkKxQ@mail.gmail.com>
 <CAJfpegth1vkgo67MbqfcmjXZLjxAW9mjoNaxLUW78iRtEqcaLQ@mail.gmail.com>
 <CAJfpegtay6O7S92eV0H=kV58E28z3Bmc4M0r6jYtoQkxSCjgUQ@mail.gmail.com>
 <CAOQ4uxhFSa-DAs4_7YQ0DB6yjE7Qr76Dm9TNs17L1wKAnEMy+g@mail.gmail.com>
 <CAJfpegsjfxTV44SbcKzV7T2U+BbOqgwLHgr7-jctqgUXxYzM_A@mail.gmail.com>
 <CAOQ4uxhnFeL-pHY6AM8UWD9RDu-RN=xuM-RCoq5Mw_htUvHBFA@mail.gmail.com>
 <CAJfpegv_GkeGapuTGDMtF79GL1iZK5+HA_p1+OQpqXhZsrS4JQ@mail.gmail.com>
 <CAOQ4uxgcCdpYoAbo5mp5AvdW9B-ENAJXgQbOtjsQoHKjr_b8iA@mail.gmail.com> <CAJfpegu_w+xfONCDMoqtLs=r6J8DUBjTU_W=pchRK0URum8c+Q@mail.gmail.com>
In-Reply-To: <CAJfpegu_w+xfONCDMoqtLs=r6J8DUBjTU_W=pchRK0URum8c+Q@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 29 Jan 2019 18:47:20 +0200
Message-ID: <CAOQ4uxj08PhC2+h1LL+iKrAGnKXvT-oYNkFOjUqHrnBf84DswA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

> > ./run --ov=0 --samefs rename-new-pop-dir
>
> Fix attached.

So, is sync_filesystem(sb); in ovl_remount() needed or not?

Note that ./run --ov=0 rename-mass-4
does pass but hits a WARN_ON:
[  735.666817] WARNING: CPU: 1 PID: 7 at
/home/amir/build/src/linux/fs/overlayfs/file.c:913
ovl_writepage+0x71/0x113

The WARN_ON is also hit by xfstest overlay/030.

In both cases its an extending write where pos == size

It seems to me that simple_write_end() is indeed too simple
and compared to __generic_write_end() it is missing at least
pagecache_isize_extended() which seems related to the WARN_ON.
I tried several fixes, but gave up.

I found one fix for overlay/001 failure:

@@ -65,7 +65,8 @@ static struct file *ovl_open_upper(const struct file *file,
        ovl_path_upper(file_dentry(file), &realpath);

        old_cred = ovl_override_creds(inode->i_sb);
-       realfile = open_with_fake_path(&realpath, O_RDWR | O_NOATIME,
+       realfile = open_with_fake_path(&realpath,
+                                      O_RDWR | O_LARGEFILE | O_NOATIME,
                                       realinode, current_cred());

Other xfstests failures:
overlay/032 overlay/047 overlay/050 overlay/051

Thanks,
Amir.
