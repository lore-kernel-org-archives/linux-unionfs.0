MIME-Version: 1.0
In-Reply-To: <20181101212545.GD15140@redhat.com>
References: <20181101004813.31349-1-amir73il@gmail.com>
	<20181101004813.31349-2-amir73il@gmail.com>
	<20181101130322.GA15140@redhat.com>
	<CAJfpegsbzNR6hKVrm5+A19D2MqEQat=ytR1TUax-+O2tEb7WFA@mail.gmail.com>
	<CAJfpegsLjG3n7WhzH4YHc-aGDMR-jHOydMmMswn=d6TfPtPRpQ@mail.gmail.com>
	<20181101212545.GD15140@redhat.com>
Date: Thu, 1 Nov 2018 22:35:22 +0100
Message-ID: <CAJfpegsXtcGx18b6s5X6a_dYOB9SfeMvB=v0R=9FHAe=EsvPfw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ovl: return error on mount if metacopy cannot be enabled
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Nov 1, 2018 at 10:25 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Nov 01, 2018 at 09:41:08PM +0100, Miklos Szeredi wrote:
>> On Thu, Nov 1, 2018 at 2:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > On Thu, Nov 1, 2018 at 2:03 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> On Thu, Nov 01, 2018 at 02:48:09AM +0200, Amir Goldstein wrote:
>> >
>> >>>
>> >>>               case OPT_METACOPY_ON:
>> >>>                       config->metacopy = true;
>> >>> +                     config->strict = true;
>> >>
>> >> I think either ->strict should go in a separate patch or we should have
>> >> a good description in commit message, explaining why ->strict is there
>> >> and how it will impact behavior going forward.
>> >
>> > I'm redoing Amir's patches a bit, and at the moment I'm more inclined
>> > to leave this after the merge window, since there are so many subtle
>> > details to deal with.
>> >
>> > Back shortly with an updated set.
>>
>> ...this is more complicated than I thought.
>>
>> Anyway, pushed a metacopy fix to overlayfs-next, that I'm pretty happy with.
>>
>> I don't think erroring out on noxattr is important; falling back is
>> actually quite sane.  And it isn't going to be an issue in real life,
>> since xattr is supported on lots of fs, and it's unlikely that lots of
>> people will want to use overlayfs with e.g. minix as the upper layer.
>
> Hi Miklos,
>
> This looks reasonable to me. I tried metacopy=on and it mounted. Only
> little issue seems to be that it enables redirect_dir but it does not
> show in /proc/mounts.

That's intentional.

>
> #cat /proc/mounts | grep overlay
> none /root/overlayfs-testing/merged overlay rw,seclabel,relatime,lowerdir=lower:lower2,upperdir=upper,workdir=work,metacopy=on 0 0
>
> Is this an issue or it is fine given on same kernel configuration all
> user has to pass is "metacopy=on" to get similar mount settings. Thought
> of pointing it out to make sure this is not an issue.

Right, that's what we promise: same kernel configuration, same module
params, options copied from /proc/mounts -> same options enabled.

Thanks,
Miklos
