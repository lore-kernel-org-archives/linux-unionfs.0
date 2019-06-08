Return-Path: <mcoffin13@gmail.com>
Return-Path: <mcoffin13@gmail.com>
Subject: Re: [PATCH v2] overlay: allow config override of metacopy/redirect
 defaults
References: <20190607010431.11868-1-mcoffin13@gmail.com>
 <20190607205105.21858-1-mcoffin13@gmail.com>
 <CAOQ4uximPqsNivkqD36LdNfT4g41v2rtDm+OB6t2z40dpWs_og@mail.gmail.com>
From: Matt Coffin <mcoffin13@gmail.com>
Message-ID: <f5b0bddd-678b-bdd9-6fc7-cc9e5b3211e5@gmail.com>
Date: Sat, 8 Jun 2019 11:28:39 -0600
MIME-Version: 1.0
In-Reply-To: <CAOQ4uximPqsNivkqD36LdNfT4g41v2rtDm+OB6t2z40dpWs_og@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

Thanks for the comments, Amir. It's my first kernel patch so it's a
learning process.

I'll take a stab at fleshing out what the documentation would look like
for a different config system, and submit a patch for the redirect_dir
not showing in procfs bug. Unless there's opposition, I'll also add a
log line (similar to the one that warns about disabling metacopy) for
when redirect_dir becomes enabled due to an explicitly configured
metacopy for the mount point. A line like that in dmesg would have saved
me a log of trouble trying to figure out WHY this was happening in the
first place.

As far as docker goes, I think you're absolutely correct there. There's
no reason that the overlay2 backend shouldn't be passing these
parameters explicitly to the mount point. That said, even with the
visibility improvements above, it does seem odd to me that passing
"redirect_dir=0" explicitly to the module wouldn't actually disable it,
just because the "metacopy" parameter is defaulting it to being on. Even
if we display the overridden options in /proc/mounts, and log in dmesg,
it seems odd to me that a default on another setting would override an
explicitly passed other setting.

Hopefully, there won't be many people actually doing that globally once
the overlay2 backend behaves properly, but it still seems like odd
behavior to me; but, if that's intended and desired then it's not the
end of the world.

Thanks again for the comments and working with me. Sorry if the
[How]/[Why] formatting isn't the standard here, I just pulled it from
the amd-gfx mailing list since I've never submitted a patch before.

So, if one were to take a stab at implementing a more generic
configuration approach, what would the ideal desired behavior for the
options look like?

1. Should kernel config not be override-able? The current behavior is to
allow overriding kernel config with mount options/params. It might be
confusing to change that, so likely the desire would be to keep the
existing behavior?
2. Should mount options take precedence over module params? The current
behavior is that mount options take precedence, and likely I think
that's desired as well.

Thanks in advance for the help,
Matt Coffin

On 6/8/19 3:04 AM, Amir Goldstein wrote:
> Hi Matt,
> 
> Thank you for trying to address this, but I see problems both in Why and
> How you did it.
> 
> On Fri, Jun 7, 2019 at 11:51 PM Matt Coffin <mcoffin13@gmail.com> wrote:
>>
>> [Why]
>> Currently, if the redirect_dir option is set as a kernel or module
>> parameter, then even if metacopy is only enabled config, then both
>> metacopy and redirect_dir will be enabled when one creates a mount
>> point. This is not desirable because /sys/module/overlay/parameters will
>> still report that redirect_dir is not enabled
> 
> /sys/module/overlay/parameters reports that redirect_dir is not enabled
> *by default* not per mount.
> 
>> and there will be no redirect_dir=on line in the mount options in /proc/mounts.
> 
> That is a bug. This code:
> /* Automatically enable redirect otherwise. */
> config->redirect_follow = config->redirect_dir = true;
> 
> Needs to update of config->redirect_mode.
> 
> You are very welcome to send a fix patch.
> 
>> The behavior
>> of setting redirect_dir globally for overlay is likely a common pattern
>> on docker workstations, as redirect_dir makes for slower building of
>> docker images.
> 
> I haven't been following the progress in docker w.r.t redirect_dir,
> but IMO the right way for docker is to always mandate overlayfs
> mount option parameters based on user meaningful storage driver
> config options, see:
> https://github.com/moby/moby/pull/34342#issuecomment-320669900
> 
> Instead of depending on admin to set /sys/module/overlay/parameters
> globally, docker should always pass explicit redirect_dir,metacopy
> values in mount options.
> Docker should check for existence of /sys/module/overlay/parameters
> feature file to know if kernel supports the mount option.
> 
> BTW, docker should be treating metacopy exactly the same way as
> redirect_dir because the native diff driver does not know about metacopy,
> so docket should (IMO) disable metacopy in mount option unless user
> explicitly opted-in for in per image and fallback to naiive diff driver if
> user opted-in to enable metacopy.
> 
> IMO, docker overlay2 storage driver should have a well documented
> user meaningful per container option such as:
> "optimize for efficient runtime" (redirect_dir=on,metacopy=on)
> vs.
> "optimize for efficient image export" (redirect_dir=off,metacopy=off)
> 
> Or even simpler:
> "Exportable = true/false"
> Because users know if they run a container that they don't intend
> to export. In that case, it makes no sense to deny user of the benefits
> of redirect_dir=on,metacopy=on.
> 
>>
>> [How]
>> This patch adds similar logic to that already in place for parsing mount
>> parameters. If the user explicitly sets redirect_dir via a kernel or
>> module parameter, then metacopy will become disabled, unless it was also
>> specified that way. Obviously, mount options still take precedence over
>> this process, so this logic only kicks in when neither redirect_dir or
>> metacopy were specified in the mount options.
>>
> 
> If even we did pass the "Why", the "How" is unacceptable IMO.
> It extends something that is already a local special case hack
> with redirect_opt/metacopy_opt.
> 
> If we ever try to improve parameter/config/option parsing
> and dependency checks we need to do it in a much more generic
> way and there are much more things to consider.
> I am sorry that I cannot provide you guidelines for how to
> do this. I took a stab at this once, then Miklos said he will try to
> redo it and came back with:
> "...this is more complicated than I thought."
> https://marc.info/?l=linux-unionfs&m=154110487305120&w=2
> 
> If you do insist to try and follow this path, my only suggestion
> is - start with a patch to Documentation/filesystems/overlayfs.txt.
> If you cannot shortly and properly describe the behavior of
> your change in documentation it is a no go.
> 
> Thanks,
> Amir.
> 
