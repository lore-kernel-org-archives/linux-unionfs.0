MIME-Version: 1.0
In-Reply-To: <CAOQ4uxh+yP2337Qd-WroTU7kPRn=7i__AjPLyEJs07DRxME5qw@mail.gmail.com>
References: <20181101004813.31349-1-amir73il@gmail.com>
	<20181101004813.31349-2-amir73il@gmail.com>
	<20181101130322.GA15140@redhat.com>
	<CAJfpegsbzNR6hKVrm5+A19D2MqEQat=ytR1TUax-+O2tEb7WFA@mail.gmail.com>
	<CAJfpegsLjG3n7WhzH4YHc-aGDMR-jHOydMmMswn=d6TfPtPRpQ@mail.gmail.com>
	<CAOQ4uxg42nW4V5RdbLq9w2Vk1zUBwGBpxSREgKnm7s46da0RKg@mail.gmail.com>
	<CAJfpegsDhAdMCxqL4GBu9PxvDy2=q+syvoyfR8=k-77h=b_Hag@mail.gmail.com>
	<CAOQ4uxjt3USJM59i_8b2-uuyppyRmJ9t0=LLbqVSKdK4vm77NQ@mail.gmail.com>
	<CAJfpegvhsCgRYBbSBi2HzwMF1ZDuMvoxt0u14Zdm2nQchpUN1w@mail.gmail.com>
	<CAOQ4uxh+yP2337Qd-WroTU7kPRn=7i__AjPLyEJs07DRxME5qw@mail.gmail.com>
Date: Wed, 7 Nov 2018 13:09:21 +0100
Message-ID: <CAJfpegtPfiy-44b8-EgFSp8fWp-h9b7=+TjO5ncKKbq_GqUSRQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ovl: return error on mount if metacopy cannot be enabled
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Nov 7, 2018 at 12:59 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> OK. (including RENAME_WHITEOUT and d_type)
>
> But what about being "strict" about the need for underlying fs
> to support file handles for index and nfs_export?

Yes, that one as well.

> The "thorny part" is that with your implementation of
> metacopy/redirect_dir all the decisions can be made at the end of options
> parsing. With nfs_export, mount option can turn it on and then no file handle
> support will turn it off.
> If at option parsing time we let nfs_export imply !redirect_dir, we are
> left with !redirect_dir and !nfs_export.

We could do the option interdependency resolution after detecting features.

> and Kconfig will choose metacopy if both are set to Y...
>
> I think current direction makes sense. In the system/distro level it makes
> sense for the default to be efficient in copy up. In the fs instance level,
> user/application can opt-in for NFS export feature in favor of efficient
> copy up.

Makes sense.

Thanks,
Miklos
